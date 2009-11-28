require File.dirname(__FILE__) + '/base'

module Acceptance
  module Reflections
    class Format < Base
      
      def initialize(*args)
        super
        @macro = :format
      end
      
      def pattern
        @options[:with]
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

