require 'spec_helper'

require 'capybara/rspec'
require 'capybara/firebug'

require 'support/test_app/test_app'
require 'support/site_prism/pages/test_app'

require 'support/helpers/integration/vcr'

Capybara.app = TestApp
Capybara.default_driver = :selenium

Selenium::WebDriver::Firefox::Profile.firebug_version = '1.11.0'

RSpec.configure do |config|
  config.include VcrHelper, type: :feature
end

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures'
  c.hook_into :webmock
  c.ignore_localhost = true
  c.preserve_exact_body_bytes { false }

  c.default_cassette_options = {
    serialize_with:         :syck,
    allow_playback_repeats: true
  }
end