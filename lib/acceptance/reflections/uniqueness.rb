require File.dirname(__FILE__) + '/base'

module Acceptance
  module Reflections
    class Uniqueness < Base

      def initialize(*args)
        super
        @macro = :uniqueness
      end

      option_reader :scope

      def case_sensitive?
        !@options.has_key?(:case_sensitive) or @options[:case_sensitive]
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

