module Acceptance
  module FormHelper
    
    def validated_form_for(*args, &block)
      form_for(*args, &block)
      concat(acceptance_builder.flush_rules, block.binding)
    end
    
    def validated_fields_for(*args, &block)
      fields_for(*args, &block)
      concat(Acceptance.flush_rules, block.binding)
    end
    
    def acceptance_builder
      @acceptance_builder ||= Builder.new
    end
    
  end
end

