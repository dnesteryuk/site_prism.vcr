# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'site_prism_vcr/version'

Gem::Specification.new do |spec|
  spec.name          = 'site_prism.vcr'
  spec.version       = SitePrism::Vcr::VERSION
  spec.authors       = ['Dmitriy Nesteryuk']
  spec.email         = ['nesterukd@gmail.com']
  spec.description   = 'This gem integrates VCR library into SitePrism'
  spec.summary       = 'TODO: write description'
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'site_prism', '2.2'
  spec.add_dependency 'vcr', '2.4.0'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'capybara'
end
