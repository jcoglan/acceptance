module Acceptance
  module Reflections
    class Base
      
      attr_reader :macro, :field
      
      def initialize(field, options = {})
        @field = field.to_sym
        @options = options
      end
      
      def options
        @options.dup
      end
      
      def message
        options[:message]
      end
      
    end
  end
end

