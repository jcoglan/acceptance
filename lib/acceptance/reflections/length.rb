require File.dirname(__FILE__) + '/base'

module Acceptance
  module Reflections
    class Length < Base
      
      def initialize(*args)
        super
        @macro = :length
      end
      
      option_reader :minimum, :maximum, :is
      
      def within
        @options[:within] || @options[:in]
      end
      alias :in :within
      
      {:too_long => [:maximum, :end], :too_short => [:minimum, :begin], :wrong_length => [:is]}.each do |message_type, (constraint, range_attr)|
        define_method(message_type) do
          if @options.has_key?(:message)
            "#{ @field.to_s.humanize } #{ @options[:message] }"
          elsif @options.has_key?(message_type)
            "#{ @field.to_s.humanize } #{ @options[message_type] }"
          else
            count = @options[constraint] || (within && range_attr && within.__send__(range_attr))
            count && ActiveRecord::Error.new(@model.new, @field, message_type, :count => count).full_message
          end
        end
      end
      
      def allow_nil?
        !!@options[:allow_nil]
      end
      
      def allow_blank?
        !!@options[:allow_blank]
      end
      
    private
      
      def generate_message
        messages = [too_long, too_short, wrong_length].compact
        messages.length == 1 ? messages.first : nil
      end
      
    end
  end
end

