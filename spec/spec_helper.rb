require 'bundler/setup'

require 'rspec'
require 'coveralls'

require 'site_prism.vcr'

Coveralls.wear!

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures'
end