require 'fileutils'
require 'find'

VALIDATION_CONFIG = File.dirname(__FILE__) + '/../../config/validation/'
FileUtils.mkdir_p(VALIDATION_CONFIG)

After do
  Given "I remove all validations"
end

Given /^the Article class validates acceptance of (\S+)$/ do |field|
  File.open(VALIDATION_CONFIG + 'article.rb', 'w') do |f|
    f.write <<-CODE
    class Article
      validates_acceptance_of :#{field}
    end
    CODE
  end
end

Given /^I remove all validations$/ do
  Find.find(VALIDATION_CONFIG) do |path|
    File.delete(path) if File.file?(path)
  end
end

When /^I visit "([^\"]*)"$/ do |path|
  $browser.goto @host + path
end

When /^I focus the check box "([^\"]*)"$/ do |field|
  find_by_label_or_id(:check_box, field).focus
end

When /^I focus the button "([^\"]*)"$/ do |button|
  $browser.button(:text, button).focus
end

