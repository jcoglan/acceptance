require File.dirname(__FILE__) + '/base'

module Acceptance
  module Reflections
    class Presence < Base
      
      def initialize(*args)
        super
        @macro = :presence
      end
      
    private
      
      def generate_message
        ActiveRecord::Error.new(@model.new, @field, :blank).full_message
      end
      
    end
  end
end

