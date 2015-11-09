# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'iml_client/version'

Gem::Specification.new do |spec|
  spec.name          = 'iml_client'
  spec.version       = ImlClient::VERSION
  spec.authors       = ['Babur Usenakunov']
  spec.email         = ['bob.usenakunov@gmail.com']
  spec.summary       = %q{Client for IML logistics service API}
  spec.description   = %q{Client for IML logistics service API}
  spec.homepage      = 'https://github.com/bob-frost/iml_client'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']
  
  spec.add_dependency 'httparty', '~> 0.11'  

  spec.add_development_dependency 'bundler', '~> 1.0'
end
