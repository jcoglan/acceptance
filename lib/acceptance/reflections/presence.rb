require File.dirname(__FILE__) + '/base'

module Acceptance
  module Reflections
    class Presence < Base
      
      def initialize(*args)
        super
        @macro = :presence
      end
      
    end
  end
end

