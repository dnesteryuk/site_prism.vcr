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
  spec.summary       = 'VCR and SitePrism are awesome libraries. But, it is a bit difficult to work with them without some bridge between them. This gem combines these 2 libraries to provide a better way for stubbing external API request which your application is doing. This gem will be very helpful for developers which have an application working with an external API.'
  spec.homepage      = 'https://github.com/nestd/site_prism.vcr'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'site_prism', '~> 2.4'
  spec.add_dependency 'vcr',        '2.4.0'
  spec.add_dependency 'webmock'
end
