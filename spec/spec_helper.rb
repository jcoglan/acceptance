require 'rubygems'
require 'active_record'

require File.dirname(__FILE__) + '/../lib/acceptance'

module SpecHelper
  def make_class(&block)
    Class.new(ActiveRecord::Base) do
      set_table_name :sti
      extend Acceptance::ReflectsOnValidations
      instance_eval(&block)
    end
  end
  
  def reflect(field)
    @class.reflect_on_validations_for(field)
  end
  
  def reflect_validation_of(field, macro, options = {})
    ReflectionMatcher.new(field, macro, options)
  end
  
  class ReflectionMatcher
    def initialize(field, macro, options)
      @field, @macro, @options = field, macro, options
    end
    
    def matches?(actual)
      actual.should_not == nil
      
      actual.field.should == @field
      actual.macro.should == @macro
      
      @options.each { |key, value| actual.__send__(key).should == value }
    end
  end
end

ActiveRecord::Base.establish_connection(
    :adapter  => 'sqlite3',
    :database => ':memory:')

ActiveRecord::Schema.define do
  create_table :sti, :force => true do |t|
    t.string :username
    t.string :email
    t.string :password
    t.integer :age
  end
end

