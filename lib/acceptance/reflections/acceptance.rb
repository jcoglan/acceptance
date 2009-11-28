require File.dirname(__FILE__) + '/base'

module Acceptance
  module Reflections
    class Acceptance < Base
      
      def initialize(*args)
        super
        @macro = :acceptance
      end
      
    end
  end
end

