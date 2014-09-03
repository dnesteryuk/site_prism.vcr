require 'bundler/setup'

require 'rspec'
require 'coveralls'

require 'site_prism.vcr'

Coveralls.wear!

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_doubled_constant_names = true
  end
end

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures'

  c.default_cassette_options = {
    erb: {
      port: 111
    }
  }
end