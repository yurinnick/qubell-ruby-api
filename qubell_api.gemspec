# Encoding: utf-8

Gem::Specification.new do |s|
  s.name        = 'qubell_api'
  s.version     = '0.1.0'
  s.date        = '2014-05-23'
  s.summary     = 'Qubell API Wrapper'
  s.authors     = ['Nikolay Yurin']
  s.email       = 'yurinnick@outlook.com'
  s.files       = %x{git ls-files}.split("\n")
  s.homepage    =
    'http://rubygems.org/gems/hola'
  s.license       = 'apache2'
  s.require_paths = ['lib']
  s.add_dependency 'rest-client'
end
