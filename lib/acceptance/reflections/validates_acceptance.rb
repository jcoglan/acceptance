module Acceptance
  module Reflections
    class ValidatesAcceptance < Base
      
      def initialize(field)
        @field = field.to_sym
        @macro = :acceptance
      end
      
    end
  end
end

