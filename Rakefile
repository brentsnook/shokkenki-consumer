require 'rubygems'
require 'bundler'
require 'cucumber/rake/task'
require_relative 'lib/shokkenki/consumer/version'

Bundler.setup
Bundler::GemHelper.install_tasks

require 'rake'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "features --format pretty"
end

desc 'Push features to shokkenki project site for current version of the shokkenki consumer'
task :relish do
  sh "relish push shokkenki/shokkenki-consumer:#{Shokkenki::Consumer::Version::STRING.split('.')[0..1].join('.')}"
end

task :default => [:spec]
