require File.dirname(__FILE__) + '/base'

module Acceptance
  module Reflections
    class Acceptance < Base
      
      def initialize(*args)
        super
        @macro = :acceptance
      end
      
      def allow_nil?
        !@options.has_key?(:allow_nil) or @options[:allow_nil]
      end
      
      def accept
        @options[:accept] || "1"
      end
      
    private
      
      def generate_message
        ActiveRecord::Error.new(@model.new, @field, :accepted).full_message
      end
      
    end
  end
end

