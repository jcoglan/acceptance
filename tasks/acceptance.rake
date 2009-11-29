require 'fileutils'

namespace :acceptance do
  task :install do
    plugin_dir = File.expand_path(File.dirname(__FILE__) + '/..')
    app_dir = plugin_dir + '/../../..'
    
    require plugin_dir + '/vendor/jake/lib/jake'
    puts 'Building JavaScript client ...'
    Jake.build!(plugin_dir)
    
    puts 'Copying client into public/javascripts ...'
    FileUtils.cp plugin_dir + '/javascript/build/acceptance.js',
                 app_dir + '/public/javascripts/acceptance.js'
  end
end

