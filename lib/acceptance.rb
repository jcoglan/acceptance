Dir[File.dirname(__FILE__) + '/acceptance/**/*.rb'].each { |f| require f }

if defined?(ActionView)
  require File.dirname(__FILE__) + '/view_extensions'
end

module Acceptance
  class << self
    attr_accessor :generator
    
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
      @builder = generator.new(@form_id, @object, @object_name)
    end
    
    def add_field(method)
      @builder << method
    end
    
    def flush_rules
      return "" unless has_form? and @object
      @builder.generate_script
    end
    
  end
  
  self.generator = DefaultGenerator
end

