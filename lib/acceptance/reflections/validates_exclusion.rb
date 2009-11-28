module Acceptance
  module Reflections
    class ValidatesExclusion < Base
      
      def initialize(*args)
        super
        @macro = :exclusion
      end
      
      def in
        @options[:in].dup
      end
      
      def allow_nil?
        !!@options[:allow_nil]
      end
      
      def allow_blank?
        !!@options[:allow_blank]
      end
      
    end
  end
end

