ActiveRecord::Schema.define do
  create_table :articles, :force => true do |t|
    t.timestamps
    t.string :title
  end
end

class Article < ActiveRecord::Base
  extend Acceptance::ReflectsOnValidations
  
  validates_length_of :title, :is => 6,:message => 'foom'
end

