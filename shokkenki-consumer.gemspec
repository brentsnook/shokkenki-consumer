# -*- encoding: utf-8 -*-
$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'shokkenki/consumer/version'

Gem::Specification.new do |s|
  s.name = 'shokkenki-consumer'
  s.version = Shokkenki::Consumer::Version::STRING
  s.platform = Gem::Platform::RUBY
  s.license = 'GPL2'
  s.authors = ['Brent Snook']
  s.email = 'brent@fuglylogic.com'
  s.homepage = 'http://github.com/brentsnook/shokkenki-consumer'
  s.summary = "shokkenki-consumer-#{Shokkenki::Consumer::Version::STRING}"
  s.description = 'Example-driven consumer-driven contracts. For consumers.'

  s.files = `git ls-files -- lib/*`.split("\n")
  s.test_files = s.files.grep(%r{^spec/})
  s.rdoc_options = ['--charset=UTF-8']
  s.require_path = 'lib'

  s.required_ruby_version = '>= 1.9'

  s.add_runtime_dependency 'json'
  s.add_runtime_dependency 'rspec'
  s.add_runtime_dependency 'httparty'
  s.add_runtime_dependency 'find_a_port'
  s.add_runtime_dependency 'activesupport', '>= 3.0.0'
  s.add_runtime_dependency 'shokkenki-support', '~> 0.0.4'
  s.add_runtime_dependency 'rack'

  s.add_development_dependency 'rake', '~> 10.0.0'
  s.add_development_dependency 'cucumber'
  s.add_development_dependency 'timecop'
  s.add_development_dependency 'webmock'
  s.add_development_dependency 'relish'
end