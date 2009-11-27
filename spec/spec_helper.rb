require 'rubygems'
require 'active_record'

require File.dirname(__FILE__) + '/../lib/acceptance'

module SpecHelper
  def make_class(&block)
    Class.new(ActiveRecord::Base) do
      extend Acceptance::ReflectsOnValidations
      instance_eval(&block)
    end
  end
end

