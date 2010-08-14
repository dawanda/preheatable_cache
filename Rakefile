task :default => :spec
require 'spec/rake/spectask'
Spec::Rake::SpecTask.new {|t| t.spec_opts = ['--color --backtrace']}

begin
  require 'jeweler'
  project_name = 'preheatable_cache'
  Jeweler::Tasks.new do |gem|
    gem.name = project_name
    gem.summary = "Reduce cache requests by preheating via multi_get"
    gem.email = "grosser.michael@gmail.com"
    gem.homepage = "http://github.com/grosser/#{project_name}"
    gem.authors = ["Michael Grosser"]
  end

  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler, or one of its dependencies, is not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end