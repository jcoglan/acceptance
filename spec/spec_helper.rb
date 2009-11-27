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
end

ActiveRecord::Base.establish_connection(
    :adapter  => 'sqlite3',
    :database => ':memory:')

ActiveRecord::Schema.define do
  create_table :sti, :force => true do |t|
  end
end

