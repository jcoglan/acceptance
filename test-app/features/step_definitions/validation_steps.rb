Given /^there is an Article class$/ do
  ::Article = Class.new(ActiveRecord::Base)
  ::Article.extend(Acceptance::ReflectsOnValidations)
end

Given /^I have specified a code generator$/ do
  Acceptance.generator = Class.new(Acceptance::Generator) {
    validate :presence do |reflection|
      "form('#{form_id}').requires('#{reflection.field}');"
    end
  }
end

Given /^the Article class requires "([^\"]*)" to be present$/ do |field|
  ::Article.validates_presence_of field
end

Then /^I should see a form$/ do
  response.should have_tag('form')
end


Then /^I should see a script containing$/ do |string|
  Then "I should see \"#{ string }\" within \"script\""
end

