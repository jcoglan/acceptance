Given /^there is an Article class$/ do
  ::Article = Class.new(ActiveRecord::Base) do
    extend(Acceptance::ReflectsOnValidations)
    attr_accessor :password, :password_confirmation
  end
end

Given /^the Acceptance generator is disabled$/ do
  Acceptance::Generator.disable!
end


Given /^I have specified a code generator$/ do
  Acceptance.generator = Class.new(Acceptance::Generator) {
    validate :length do |reflection|
      "form('#{form_id}').requires('#{object_name}[#{reflection.field}]').toHaveLength(#{reflection.is});"
    end
    
    validate :presence do |reflection|
      "form('#{form_id}').requires('#{object_name}[#{reflection.field}]');"
    end
    
    validate :uniqueness do |reflection|
      "form('#{form_id}').requires('#{object_name}[#{reflection.field}]').toBeUnique();"
    end
  }
end

Given /^the Article class requires "([^\"]*)" to have length (\d+)$/ do |field, length|
  ::Article.validates_length_of field, :is => length.to_i
end

Given /^the Article class requires "([^\"]*)" to have length (\d+) on "([^\"]*)"$/ do |field, length, event|
  ::Article.validates_length_of field, :is => length.to_i, :on => event.to_sym
end

Given /^the Article class requires "([^\"]*)" to be present$/ do |field|
  ::Article.validates_presence_of field
end

Given /^the Article class requires "([^\"]*)" to be unique$/ do |field|
  ::Article.validates_uniqueness_of field
end

Then /^I should see a form called "([^\"]*)"$/ do |id|
  response.should have_tag('form#' + id)
end

Then /^I should not see a script called "([^\"]*)"$/ do |id|
  response.should_not have_selector("script\##{id}")
end

Then /^I should see a script called "([^\"]*)" containing$/ do |id, string|
  Then "I should see \"#{ string }\" within \"script\##{ id }\""
end

Then /^I should see a script called "([^\"]*)" not containing$/ do |id, string|
  Then "I should not see \"#{ string }\" within \"script\##{ id }\""
end

