require 'rubygems'
require 'rake'
require 'jeweler'

Jeweler::Tasks.new do |gemspec|
  gemspec.name = 'rtunesu'
  gemspec.summary = "A library for using Apple's iTunes U Webservices API"
  gemspec.description = "A library for using Apple's iTunes U Webservices API"
  gemspec.email = 'pietrekg@umich.edu'
  gemspec.authors = ['Trek Glowacki']
  gemspec.add_dependency('hpricot', '>= 0.6.164')
  gemspec.add_dependency('builder', '>= 2.0')
end
Jeweler::GemcutterTasks.new

Dir['tasks/**/*.rake'].each { |rake| load rake }