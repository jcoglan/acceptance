module Acceptance
  module Reflections
    class ValidatesConfirmation < Base
      
      def initialize(*args)
        super
        @macro = :confirmation
      end
      
    end
  end
end

