ActiveRecord::Schema.define do
  create_table :articles, :force => true do |t|
    t.timestamps
    t.string :title
  end
end

class Article < ActiveRecord::Base
  extend Acceptance::ReflectsOnValidations
  attr_accessor :password, :password_confirmation
  
  validates_presence_of :title, :message => 'must not be blank'
  validates_length_of :title, :is => 6,:message => 'must be 6 characters'
  validates_confirmation_of :password, :message => 'must match password'
end

