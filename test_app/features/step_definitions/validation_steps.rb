require 'fileutils'
require 'find'

VALIDATION_CONFIG = File.dirname(__FILE__) + '/../../config/validation/'
FileUtils.mkdir_p(VALIDATION_CONFIG)

module CodeInjection
  def inject_code(class_name, code)
    File.open(VALIDATION_CONFIG + class_name.tableize.singularize + '.rb', 'w') do |f|
      f.write <<-CODE
      class #{class_name}
        #{code}
      end
      CODE
    end
  end
end

World CodeInjection

After { Given "I remove all validations" }

Given /^I remove all validations$/ do
  Find.find(VALIDATION_CONFIG) { |path| File.delete(path) if File.file?(path) }
end

Given /^the (\S+) class validates (\S+) of (\S+)$/ do |class_name, validation, field|
  inject_code class_name, "validates_#{validation}_of :#{field}"
end

Given /^the (\S+) class validates (\S+) of (\S+) on (\S+)$/ do |class_name, validation, field, event|
  inject_code class_name, "validates_#{validation}_of :#{field}, :on => :#{event}"
end

Given /^the (\S+) class validates (\S+) of (\S+) with message "([^\"]*)"$/ do |class_name, validation, field, message|
  inject_code class_name, "validates_#{validation}_of :#{field}, :message => \"#{message}\""
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

