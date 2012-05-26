require 'bundler'
require 'bundler/version'

require File.expand_path('lib/klout/version')

Gem::Specification.new do |s|
  s.add_runtime_dependency('hashie')
  s.add_runtime_dependency('httparty')
  s.add_runtime_dependency('json')
  s.add_development_dependency('fakeweb')
  s.add_development_dependency('guard-rspec')
  s.add_development_dependency('rspec')
  s.name = "klout"
  s.authors = ["Brian Getting"]
  s.description = %q{Implements the complete functionality of the Klout REST API (v2+).}
  s.email = ["brian@tatem.ae"]
  s.executables = `git ls-files -- bin/*`.split("\n").map{|f| File.basename(f)}
  s.extra_rdoc_files = ["README.rdoc"]
  s.files = `git ls-files`.split("\n")
  s.homepage = "http://github.com/terra-firma/klout"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.summary = %q{A library which implements the complete functionality of of the Klout REST API (v2+).}
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.version = Klout::VERSION
  s.platform = Gem::Platform::RUBY
  s.required_rubygems_version = Gem::Requirement.new('>= 1.3.6') if s.respond_to? :required_rubygems_version=
end