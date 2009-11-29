ActiveRecord::Schema.define do
  create_table :articles, :force => true do |t|
    t.timestamps
    t.string :title
  end
end

class Article < ActiveRecord::Base
  extend Acceptance::ReflectsOnValidations
  
  validates_presence_of :title
end

