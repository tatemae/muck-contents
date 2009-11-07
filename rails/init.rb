ActiveSupport::Dependencies.load_once_paths << lib_path # disable reloading of this plugin

begin
  require 'babelphish'
rescue LoadError
  puts "Please install the babelphish gem"
end

if config.respond_to?(:gems)
  config.gem "sanitize"
else
  begin
    require 'sanitize'
  rescue LoadError
    begin
      gem 'sanitize'
    rescue Gem::LoadError
      puts "Please install the sanitize gem"
    end
  end
end

require 'muck_contents'
require 'muck_contents/initialize_routes'
