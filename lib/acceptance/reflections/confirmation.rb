require File.dirname(__FILE__) + '/base'

module Acceptance
  module Reflections
    class Confirmation < Base
      
      def initialize(*args)
        super
        @macro = :confirmation
      end
      
    end
  end
end

