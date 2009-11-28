module Acceptance
  module ReflectsOnValidations
    
    VALIDATION_TYPES = %w[acceptance confirmation exclusion inclusion format]
    
    def self.extract_options_from_array(attr_names)
      attr_names.last.is_a?(Hash) ? attr_names.pop : {}
    end
    
    def reflect_on_all_validations
      validations.inject([]) { |list, (field,v)| list + v }
    end
    
    def reflect_on_validations_for(field)
      (validations[field.to_sym] || []).dup
    end
    
    VALIDATION_TYPES.each do |validation_type|
      define_method "validates_#{validation_type}_of" do |*attr_names|
        super(*attr_names)
        options = ReflectsOnValidations.extract_options_from_array(attr_names)
        attr_names.each do |attribute|
          key = attribute.to_sym
          validations[key] ||= []
          validations[key] << Reflections.create(validation_type, key, options)
        end
      end
    end
    
  private
    
    def validations
      @validations ||= {}
    end
    
  end
end

