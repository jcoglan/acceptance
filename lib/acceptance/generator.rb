module Acceptance
  class Generator
    
    def self.validate(macro, &block)
      define_method("generate_#{macro}_validation", &block)
    end
    
    def self.message(macro, &block)
      define_method("generate_#{macro}_message", &block)
    end
    
    attr_reader :form_id, :object_name
    
    def initialize(form_id, object, name)
      @form_id      = form_id
      @object       = object
      @object_name  = name
      @fields       = []
    end
    
    def <<(field)
      field = field.to_sym
      @fields << field unless @fields.include?(field)
    end
    
    def generate_script
      ERB.new(TEMPLATE, nil, '-').result(binding)
    end
    
  private
    
    def validations
      @object.class.reflect_on_all_validations.select do |validation|
        @fields.include?(validation.field)
      end
    end
    
    def generate_code_for(validation)
      return "" if validation.on == :update and @object.new_record?
      return "" if validation.on == :create and not @object.new_record?
      
      method = "generate_#{validation.macro}_validation"
      return "" unless respond_to?(method)
      
      __send__(method, validation)
    end
    
    def message_for(validation)
      method = "generate_#{validation.macro}_message"
      message = respond_to?(method) ?
                __send__(method, validation) :
                "#{ validation.field.to_s.humanize } #{ validation.message }"
      message.inspect
    end
    
    TEMPLATE = <<-JAVASCRIPT
    <script type="text/javascript" id="<%= form_id %>_validation">
    (function() {
      <% validations.each do |validation| -%>
        <%= generate_code_for validation %>
      <% end -%>
    })();
    </script>
    JAVASCRIPT
    
  end
  
  class DefaultGenerator < Generator
    def rule_base(validation)
      "Acceptance.form('#{ form_id }').requires(#{ field_name_for validation })"
    end
    
    def field_name_for(validation)
      "'#{ object_name }[#{ validation.field }]'"
    end
    
    validate :acceptance do |validation|
      "#{ rule_base validation }.toBeChecked(#{ message_for validation });"
    end
    
    validate :confirmation do |validation|
      <<-SCRIPT
      Acceptance.form('#{ form_id }').
      requires('#{ object_name }[#{ validation.field }_confirmation]').
      toConfirm(#{ field_name_for validation }, #{ message_for validation });
      SCRIPT
    end
    
    validate :exclusion do |validation|
      "#{ rule_base validation }.toBeNoneOf(#{ validation.in.to_a.inspect }, #{ message_for validation});"
    end
    
    validate :inclusion do |validation|
      "#{ rule_base validation }.toBeOneOf(#{ validation.in.to_a.inspect }, #{ message_for validation});"
    end
    
    validate :format do |validation|
      pattern = validation.pattern
      flags = (pattern.options & Regexp::IGNORECASE).nonzero? ? 'i' : ''
      "#{ rule_base validation }.toMatch(/#{ pattern.source }/#{ flags }, #{ message_for validation });"
    end
    
    validate :length do |validation|
      if validation.is
        value = validation.is
      else
        range = validation.within # TODO alias as #in
        min = range ? range.min : validation.minimum
        max = range ? range.max : validation.maximum
        value = "{" + [min && "minimum: #{min}", max && "maximum: #{max}"].compact.join(', ') + "}"
      end
      "#{ rule_base validation }.toHaveLength(#{ value }, #{ message_for validation });"
    end
    
    validate :presence do |validation|
      <<-SCRIPT
      Acceptance.form('#{ form_id }').
      requires(#{ field_name_for validation }, #{ message_for validation });
      SCRIPT
    end
  end
  
end

