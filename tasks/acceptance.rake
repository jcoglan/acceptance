require 'fileutils'

namespace :acceptance do
  task :install do
    plugin_dir = File.expand_path(File.dirname(__FILE__) + '/..')
    app_dir = plugin_dir + '/../../..'
    
    begin
      require 'jake'
    rescue LoadError
      puts 'You need Jake to build the client. Just run:'
      puts '[sudo] gem install jake'
    end
    
    puts 'Building JavaScript client ...'
    Jake.build!(plugin_dir)
    
    puts 'Copying client into public/javascripts ...'
    FileUtils.cp plugin_dir + '/javascript/build/acceptance.js',
                 app_dir + '/public/javascripts/acceptance.js'
  end
end

