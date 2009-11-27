module Acceptance
  module ReflectsOnValidations
    
    def reflect_on_validations_for(field)
      (@validations[field.to_sym] || []).dup
    end
    
    def validates_acceptance_of(*attr_names)
      attr_names.each do |attribute|
        key = attribute.to_sym
        validations[key] ||= []
        validations[key] << Reflections::ValidatesAcceptance.new(key)
      end
    end
    
  private
    
    def validations
      @validations ||= {}
    end
    
  end
end

