module Acceptance
  module Reflections
    class ValidatesAcceptance < Base
      
      def initialize(*args)
        super
        @macro = :acceptance
      end
      
    end
  end
end

