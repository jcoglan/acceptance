require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'fileutils'

desc 'Build the JavaScript client'
task :build do
  require 'vendor/jake/lib/jake'
  puts 'Building JavaScript client ...'
  Jake.build!(File.dirname(__FILE__))
  
  FileUtils.mkdir_p 'test-app/public/javascripts'
  FileUtils.cp 'javascript/build/acceptance.js', 'test-app/public/javascripts/acceptance.js'
end

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the acceptance plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate documentation for the acceptance plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Acceptance'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
