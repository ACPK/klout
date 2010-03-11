require 'rubygems'
require 'echoe'
require 'fileutils'
require './lib/klout'

Echoe.new 'klout', '0.1.0'  do |p|
  p.author = 'Jason Torres'
  p.email = 'jason.e.torres@gmail.com'
  p.url = 'http://github.com/jasontorres/klout'
  p.description = "Klout - Twitter Analytics"
  p.runtime_dependencies = ["typhoeus"]

end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }