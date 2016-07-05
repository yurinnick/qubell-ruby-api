# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'qubell/version'

Gem::Specification.new do |spec|
  spec.name          = 'qubell_api'
  spec.version       = Qubell::VERSION
  spec.authors       = ['Nikolay Yurin']
  spec.email         = ['yurinnick@outlook.com']
  spec.summary       = 'Qubell API wrapper'
  spec.description   = 'Qubell API wrapper'
  spec.homepage      = 'https://github.com/yurinnick/qubell-ruby-api'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{/^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{/^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'rest-client', '~> 2.0.0'

  spec.add_development_dependency 'bundler', '~> 1.11.0'
  spec.add_development_dependency 'rake', '~> 11.2.0'
  spec.add_development_dependency 'webmock', '~> 2.1.0'
  spec.add_development_dependency 'rspec', '~> 3.5.0'
  spec.add_development_dependency 'rubocop', '~> 0.41.0'
  spec.add_development_dependency 'yard', '~> 0.9.0'
  spec.add_development_dependency 'factory_girl', '~> 4.7.0'
  spec.add_development_dependency 'simplecov', '~> 0.12.0'
end
