require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

desc 'Default: run unit tests.'
task :default => :test

desc 'Test muck-contents.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test/rails_root/test'
  t.pattern = 'test/rails_root/test/**/*_test.rb'
  t.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |t|
    #t.libs << 'lib'
    t.libs << 'test/rails_root/lib'
    t.pattern = 'test/rails_root/test/**/*_test.rb'
    t.verbose = true
    t.output_dir = 'coverage'
    t.rcov_opts << '--exclude "gems/*"'
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

require 'rake/rdoctask'
desc 'Generate documentation for the muck-contents gem.'
Rake::RDocTask.new do |rdoc|
  if File.exist?('VERSION.yml')
    config = YAML.load(File.read('VERSION.yml'))
    version = "#{config[:major]}.#{config[:minor]}.#{config[:patch]}"
  else
    version = ""
  end

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "muck_contents #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

desc 'Translate this gem'
task :translate do
  file = File.join(File.dirname(__FILE__), 'locales', 'en.yml')
  system("babelphish -o -y #{file}")
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "muck-contents"
    gemspec.summary = "Add content to your muck based project"
    gemspec.email = "justinball@gmail.com"
    gemspec.homepage = "http://github.com/tatemae/muck_contents"
    gemspec.authors = ["Justin Ball"]
    gemspec.rubyforge_project = 'muck-contents'
    gemspec.add_dependency "muck-engine"
    gemspec.add_dependency "muck-users"
    gemspec.add_dependency "muck-comments"
    gemspec.add_dependency "awesome_nested_set"
    gemspec.add_dependency "sanitize"
    gemspec.add_dependency "acts-as-taggable-on"
    gemspec.add_dependency "friendly_id"
  end
  Jeweler::GemcutterTasks.new
  Jeweler::RubyforgeTasks.new do |rubyforge|
    rubyforge.doc_task = "rdoc"
  end
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end
