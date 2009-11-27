module Acceptance
  module ReflectsOnValidations
    
    def self.extract_options_from_array(attr_names)
      attr_names.last.is_a?(Hash) ? attr_names.pop : {}
    end
    
    def reflect_on_validations_for(field)
      (@validations[field.to_sym] || []).dup
    end
    
    def validates_acceptance_of(*attr_names)
      options = ReflectsOnValidations.extract_options_from_array(attr_names)
      attr_names.each do |attribute|
        key = attribute.to_sym
        validations[key] ||= []
        validations[key] << Reflections::ValidatesAcceptance.new(key, options)
      end
    end
    
  private
    
    def validations
      @validations ||= {}
    end
    
  end
end

