Given /^there is an Article class$/ do
  ::Article = Class.new(ActiveRecord::Base)
  ::Article.extend(Acceptance::ReflectsOnValidations)
end

Given /^I have specified a code generator$/ do
  Acceptance.generator = Class.new(Acceptance::Generator) {
    validate :length do |reflection|
      "form('#{form_id}').requires('#{object_name}[#{reflection.field}]').toHaveLength(#{reflection.is});"
    end
    
    validate :presence do |reflection|
      "form('#{form_id}').requires('#{object_name}[#{reflection.field}]');"
    end
  }
end

Given /^the Article class requires "([^\"]*)" to have length (\d+)$/ do |field, length|
  ::Article.validates_length_of field, :is => length.to_i
end

Given /^the Article class requires "([^\"]*)" to be present$/ do |field|
  ::Article.validates_presence_of field
end

Then /^I should see a form called "([^\"]*)"$/ do |id|
  response.should have_tag('form#' + id)
end


Then /^I should see a script called "([^\"]*)" containing$/ do |id, string|
  Then "I should see \"#{ string }\" within \"script\##{ id }\""
end

