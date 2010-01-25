module Acceptance
  module FormHelper
    
    def validated_form_for(*args, &block)
      form_for(*args, &block)
      script = acceptance_builder.flush_rules
      
      if yield_id = Acceptance.yield_with
        content_for(yield_id, script)
      else
        concat(script)
      end
    end
    
    def acceptance_builder
      @acceptance_builder ||= Builder.new
    end
    
  end
end

