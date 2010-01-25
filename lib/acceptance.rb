Dir[File.dirname(__FILE__) + '/acceptance/**/*.rb'].each { |f| require f }

if defined?(ActionView)
  require File.dirname(__FILE__) + '/view_extensions'
end

module Acceptance
  class << self
    attr_accessor :generator
    
    def yield_with(identifier = nil)
      return @yield_identifier if identifier.nil?
      @yield_identifier = identifier
    end
  end
  
  self.generator = DefaultGenerator
end

