class Article < ActiveRecord::Base
  extend Acceptance::ReflectsOnValidations
  attr_accessor :terms, :password_confirmation
end

file = File.dirname(__FILE__) + '/../../config/validation/article.rb'
load file if File.file?(file)

