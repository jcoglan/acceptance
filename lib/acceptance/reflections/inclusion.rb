require File.dirname(__FILE__) + '/base'

module Acceptance
  module Reflections
    class Inclusion < Base
      
      def initialize(*args)
        super
        @macro = :inclusion
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

