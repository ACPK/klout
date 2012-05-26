$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "bundler/version"
require "rake/testtask"
require "./lib/klout"
require 'rspec/core'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :default => :spec

desc "Build the gem"
task :build do
  system "gem build klout.gemspec"
end

desc "Build and release the gem"
task :release => :build do
  system "gem push klout-#{CreateSend::VERSION}.gem"
end

task :default => :test