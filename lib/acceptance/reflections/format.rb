require File.dirname(__FILE__) + '/base'

module Acceptance
  module Reflections
    class Format < Base
      
      generate_message_using :invalid
      
      def initialize(*args)
        super
        @macro = :format
      end
      
      option_reader :with
      alias :pattern :with
      
      def allow_nil?
        !!@options[:allow_nil]
      end
      
      def allow_blank?
        !!@options[:allow_blank]
      end
      
    end
  end
end

