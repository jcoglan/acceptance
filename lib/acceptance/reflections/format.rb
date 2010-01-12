require File.dirname(__FILE__) + '/base'

module Acceptance
  module Reflections
    class Format < Base
      
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
      
    private
      
      def generate_message
        ActiveRecord::Error.new(@model.new, @field, :invalid).full_message
      end
      
    end
  end
end

