require 'rubygems'
require 'active_record'

require File.dirname(__FILE__) + '/../lib/acceptance'

module SpecHelper
  def make_class(&block)
    klass = Class.new(ActiveRecord::Base) do
      set_table_name :sti
      extend Acceptance::ReflectsOnValidations
      instance_eval(&block)
    end
    def klass.name; "TestClass"; end
    klass
  end
  
  def factory(klass, attributes = {})
    instance = klass.new
    
    klass.reflect_on_all_validations.each do |reflection|
      value = case reflection.macro
        when :acceptance then true
        when :inclusion then reflection.in.first
        when :exclusion then "any other value"
        when :format then reflection.pattern.source
        when :presence then true
        when :confirmation then
          instance.__send__("#{reflection.field}_confirmation=", "foo")
          "foo"
      end
      
      instance.__send__("#{reflection.field}=", value)
    end
    
    attributes.inject(instance) do |object, (key,value)|
      object.__send__("#{key}=", value)
      object
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
    t.string :address
    t.integer :age
  end
end

