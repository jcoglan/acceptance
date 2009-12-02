require File.dirname(__FILE__) + '/base'

module Acceptance
  module Reflections
    class Length < Base
      
      def initialize(*args)
        super
        @macro = :length
      end
      
      option_reader :minimum, :maximum, :is, :within, :in,
                    :too_short, :too_long, :wrong_length
      
      def allow_nil?
        !!@options[:allow_nil]
      end
      
      def allow_blank?
        !!@options[:allow_blank]
      end
      
    end
  end
end

