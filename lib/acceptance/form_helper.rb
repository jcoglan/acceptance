module Acceptance
  module FormHelper
    
    def validated_form_for(*args, &block)
      form_for(*args, &block)
      concat(acceptance_builder.flush_rules)
    end
    
    def acceptance_builder
      @acceptance_builder ||= Builder.new
    end
    
  end
end

