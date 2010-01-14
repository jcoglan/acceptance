ActiveRecord::Schema.define do
  create_table :articles, :force => true do |t|
  end
end

class Article < ActiveRecord::Base
  extend Acceptance::ReflectsOnValidations
  attr_accessor :terms
end

file = File.dirname(__FILE__) + '/../../config/validation/article.rb'
load file if File.file?(file)

