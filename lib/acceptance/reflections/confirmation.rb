require File.dirname(__FILE__) + '/base'

module Acceptance
  module Reflections
    class Confirmation < Base
      
      def initialize(*args)
        super
        @macro = :confirmation
      end
      
    private
      
      def generate_message
        ActiveRecord::Error.new(@model.new, @field, :confirmation).full_message
      end
      
    end
  end
end

