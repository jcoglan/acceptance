module ActionView
  module Helpers
    
    TAG_HELPERS = %w[check_box hidden_field password_field text_area text_field]
    
    class FormBuilder  
      old_initialize = instance_method(:initialize)
      define_method(:initialize) do |object_name, object, *args|
        Acceptance.set_object(object, object_name)
        old_initialize.bind(self).call(object_name, object, *args)
      end
      
      TAG_HELPERS.each do |helper|
        old_helper = instance_method(helper)
        define_method(helper) do |*args|
          Acceptance.add_field(args.first)
          old_helper.bind(self).call(*args)
        end
      end
    end
    
    module FormTagHelper
      old_html_options_for_form = instance_method(:html_options_for_form)
    private
      define_method(:html_options_for_form) do |*args|
        options = old_html_options_for_form.bind(self).call(*args)
        Acceptance.form = options['id']
        options
      end
    end
    
  end
end

