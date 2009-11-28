module Acceptance
  module Reflections
    
    class Base
      attr_reader :macro, :field
      
      def initialize(field, options = {})
        @field = field.to_sym
        @options = options
      end
      
      def message
        msg = @options[:message]
        msg && msg.dup
      end  
    end
    
    def self.create(type, field, options)
      const_get(type.gsub(/^(.)/) { $1.upcase }).new(field, options)
    end
    
  end
end

