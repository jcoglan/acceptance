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
      method = "generate_#{validation.macro}_validation"
      return "" unless respond_to?(method)
      __send__(method, validation)
    end
    
    def message_for(validation)
      method = "generate_#{validation.macro}_message"
      return __send__(method, validation) if respond_to?(method)
      "#{ validation.field.to_s.humanize } #{ validation.message }"
    end
    
    TEMPLATE = <<-JAVASCRIPT
    <script type="text/javascript">
    (function() {
      <% validations.each do |validation| -%>
        <%= generate_code_for validation %>
      <% end -%>
    })();
    </script>
    JAVASCRIPT
    
  end
  
  class DefaultGenerator < Generator
    validate :presence do |validation|
      <<-SCRIPT
      Acceptance.form('#{ form_id }').
      requires('#{ object_name }[#{ validation.field }]', '#{ message_for validation }');
      SCRIPT
    end
    
    message :presence do |validation|
      "Please enter a #{ validation.field.to_s.humanize.downcase }"
    end
  end
end

