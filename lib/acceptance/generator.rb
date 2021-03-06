module Acceptance
  class Generator
    
    TEMPLATE = <<-JAVASCRIPT
    <script type="text/javascript" id="<%= form_id %>_validation">
    (function() {
      <% validations.each do |validation| -%>
        <%= generate_code_for validation %>
      <% end -%>
    })();
    </script>
    JAVASCRIPT
    
    def self.disable!
      @disabled = true
    end
    
    def self.disabled?
      !!@disabled
    end
    
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
      return "" if Generator.disabled?
      ERB.new(TEMPLATE, nil, '-').result(binding)
    end
    
  private
    
    def validations
      @object.class.reflect_on_all_validations.select do |validation|
        field = (validation.macro == :confirmation) ? "#{validation.field}_confirmation" : validation.field
        @fields.include?(field.to_sym)
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
      message = respond_to?(method) ? __send__(method, validation) : validation.message
      message.inspect
    end
    
    def field_name_for(validation)
      "'#{ object_name }[#{ validation.field }]'"
    end
    
    def options_for(validation, *keys)
      options = keys.inject({}) do |table, key|
        javascript_key = key.to_s.gsub(/\?$/, "").gsub(/_([a-z])/) { $1.upcase }
        table[javascript_key] = validation.__send__(key)
        table
      end
      "{" + options.map { |(key, value)|
        print_value = (key == 'message') ? message_for(validation) : value.inspect
        "#{key}: #{print_value.gsub(/^nil$/, 'null')}"
      } * ", " + "}"
    end
  end
  
  class DefaultGenerator < Generator
    def rule_base(validation)
      "Acceptance.form('#{ form_id }').requires(#{ field_name_for validation })"
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
      <<-SCRIPT
      #{ rule_base validation }.
      toBeNoneOf(#{ validation.in.to_a.inspect },
                 #{ message_for validation },
                 #{ options_for validation, :allow_blank? });
      SCRIPT
    end
    
    validate :inclusion do |validation|
      <<-SCRIPT
      #{ rule_base validation }.
      toBeOneOf(#{ validation.in.to_a.inspect },
                #{ message_for validation },
                #{ options_for validation, :allow_blank? });
      SCRIPT
    end
    
    validate :format do |validation|
      pattern = validation.pattern
      flags = (pattern.options & Regexp::IGNORECASE).nonzero? ? 'i' : ''
      <<-SCRIPT
      #{ rule_base validation }.
      toMatch(/#{ pattern.source }/#{ flags },
              #{ message_for validation },
              #{ options_for validation, :allow_blank? });
      SCRIPT
    end
    
    validate :length do |validation|
      value = if validation.is
        validation.is
      else
        range = validation.within
        min = range ? range.min : validation.minimum
        max = range ? range.max : validation.maximum
        "{" + [min && "minimum: #{min}", max && "maximum: #{max}"].compact.join(', ') + "}"
      end
      <<-SCRIPT
      #{ rule_base validation }.toHaveLength(#{ value },
      #{ options_for validation, :message, :too_short, :too_long, :wrong_length, :allow_blank? });
      SCRIPT
    end
    
    validate :presence do |validation|
      <<-SCRIPT
      Acceptance.form('#{ form_id }').
      requires(#{ field_name_for validation }, #{ message_for validation });
      SCRIPT
    end
  end
  
end

