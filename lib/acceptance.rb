Dir[File.dirname(__FILE__) + '/acceptance/**/*.rb'].each { |f| require f }

if defined?(ActionView)
  require File.dirname(__FILE__) + '/view_extensions'
end

module Acceptance
  class << self
    attr_accessor :generator
  end
  
  self.generator = DefaultGenerator
end

