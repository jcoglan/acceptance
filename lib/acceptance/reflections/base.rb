module Acceptance
  module Reflections
    
    class Base
      attr_reader :macro, :model, :field
      
      def self.option_reader(*fields)
        fields.each do |field|
          define_method(field) { @options[field] }
        end
      end
      
      def initialize(model, field, options = {})
        @model = model
        @field = field.to_sym
        @options = options
      end
      
      def message
        msg = @options[:message]
        msg && msg.dup
      end  
    end
    
    def self.create(type, model, field, options)
      const_get(type.gsub(/^(.)/) { $1.upcase }).new(model, field, options)
    end
    
  end
end

