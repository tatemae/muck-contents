require 'fileutils'
namespace :muck do
  namespace :sync do
    desc "Sync required files from muck contents."
    task :contents do
      path = File.join(File.dirname(__FILE__), *%w[.. ..])
      system "rsync -ruv #{path}/db ."
      system "rsync -ruv #{path}/public ."
      system "rsync -ruv #{path}/config/initializers ./config"
    end
  end
end