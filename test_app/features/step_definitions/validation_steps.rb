require 'fileutils'
require 'find'

VALIDATION_CONFIG = File.dirname(__FILE__) + '/../../config/validation/'
FileUtils.mkdir_p(VALIDATION_CONFIG)

module CodeInjection
  def inject_code(class_name, code)
    File.open(VALIDATION_CONFIG + class_name.tableize.singularize + '.rb', 'a') do |f|
      f.write <<-CODE
      class #{class_name}
        #{code}
      end
      CODE
    end
  end
end

World CodeInjection

After do
  Find.find(VALIDATION_CONFIG) { |path| File.delete(path) if File.file?(path) }
  Article.delete_all
end

ITEM_RE = /(?:"[^\"]*"|0|[1-9][0-9]*)/
LIST_RE = /\d+\.\.\d+|#{ITEM_RE}(?:, #{ITEM_RE})*/

Given /^the (\S+) class validates (inclusion|exclusion) of (\S+) in (#{LIST_RE}) with (\S+) (.+)$/ do |class_name, validation, field, list, option, value|
  list = "[#{list}]" unless list =~ /\d+\.\.\d+/
  inject_code class_name, "validates_#{validation}_of :#{field}, :in => #{list}, :#{option} => #{value}"
end

Given /^the (\S+) class validates (inclusion|exclusion) of (\S+) in (#{LIST_RE})$/ do |class_name, validation, field, list|
  list = "[#{list}]" unless list =~ /\d+\.\.\d+/
  inject_code class_name, "validates_#{validation}_of :#{field}, :in => #{list}"
end

Given /^the (\S+) class validates (inclusion|exclusion) of (\S+) on (\S+) in (#{LIST_RE})$/ do |class_name, validation, field, event, list|
  list = "[#{list}]" unless list =~ /\d+\.\.\d+/
  inject_code class_name, "validates_#{validation}_of :#{field}, :in => #{list}, :on => :#{event}"
end

Given /^the (\S+) class validates format of (\S+) using (\/.*\/[a-z]*)$/ do |class_name, field, pattern|
  inject_code class_name, "validates_format_of :#{field}, :with => #{pattern}"
end

Given /^the (\S+) class validates format of (\S+) on (\S+) using (\/.*\/[a-z]*)$/ do |class_name, field, event, pattern|
  inject_code class_name, "validates_format_of :#{field}, :with => #{pattern}, :on => :#{event}"
end

Given /^the (\S+) class validates format of (\S+) using (\/.*\/[a-z]*) with (\S+) (.+)$/ do |class_name, field, pattern, option, value|
  inject_code class_name, "validates_format_of :#{field}, :with => #{pattern}, :#{option} => #{value}"
end

Given /^the (\S+) class validates length of (\S+) \((\S+): (\S+)\)$/ do |class_name, field, option, value|
  inject_code class_name, "validates_length_of :#{field}, :#{option} => #{value}"
end

Given /^the (\S+) class validates (\S+) of (\S+)$/ do |class_name, validation, field|
  inject_code class_name, "validates_#{validation}_of :#{field}"
end

Given /^the (\S+) class validates (\S+) of (\S+) on (\S+)$/ do |class_name, validation, field, event|
  inject_code class_name, "validates_#{validation}_of :#{field}, :on => :#{event}"
end

Given /^the (\S+) class validates (\S+) of (\S+) with (\S+) (.+)$/ do |class_name, validation, field, option, value|
  inject_code class_name, "validates_#{validation}_of :#{field}, :#{option} => #{value}"
end

Given /^there is an Article$/ do
  Article.create
end

When /^I visit "([^\"]*)"$/ do |path|
  $browser.goto @host + path
end

When /^I focus the "([^\"]*)" field$/ do |field|
  find_by_label_or_id(:text_field, field).focus
end

When /^I focus the "([^\"]*)" check box$/ do |field|
  find_by_label_or_id(:check_box, field).focus
end

When /^I focus the "([^\"]*)" button$/ do |button|
  $browser.button(:text, button).focus
end

