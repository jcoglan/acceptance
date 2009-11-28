require File.dirname(__FILE__) + '/base'

module Acceptance
  module Reflections
    class Acceptance < Base
      
      def initialize(*args)
        super
        @macro = :acceptance
      end
      
      def allow_nil?
        @options.has_key?(:allow_nil) ? @options[:allow_nil] : true
      end
      
      def accept
        @options[:accept] || "1"
      end
      
    end
  end
end

