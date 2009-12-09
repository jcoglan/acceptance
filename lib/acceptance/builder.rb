module Acceptance
  class Builder
    
    def initialize
      clear!
    end
    
    def form=(id)
      @form_id = id.nil? ? nil : id.to_s
      set_object(nil) if @form_id.nil?
    end
    
    def has_form?
      !(@form_id.nil? or @form_id.to_s.empty?)
    end
    
    def set_object(object, name = nil)
      @object, @object_name = object, name
      return unless @object
      @generator = Acceptance.generator.new(@form_id, @object, @object_name)
    end
    
    def add_field(method)
      return unless @generator
      @generator << method
    end
    
    def flush_rules
      return "" unless has_form? and @object
      script = @generator.generate_script
      clear!
      script
    end
    
  private
    
    def clear!
      @form_id     = nil
      @object      = nil
      @object_name = nil
      @generator   = nil
    end
    
  end
end

