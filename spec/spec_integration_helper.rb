require 'spec_helper'

require 'capybara/rspec'
require 'capybara/firebug'

require 'support/test_app/test_app'
require 'support/server'

Dir["./spec/support/shared/integration/**/*.rb"].sort.each {|f| require f }
Dir["./spec/support/site_prism/pages/**/*.rb"].sort.each {|f| require f }

Capybara.app =            TestApp
Capybara.default_driver = :selenium
HTTPI.log =               false

Selenium::WebDriver::Firefox::Profile.firebug_version = '1.11.0'

Capybara.server_port = Server.find_available_port

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures'
  c.hook_into :webmock
  c.ignore_localhost = false
  c.preserve_exact_body_bytes { false }

  c.default_cassette_options = {
    serialize_with:         :psych,
    allow_playback_repeats: true,
    erb: {
      port: Capybara.server_port
    }
  }

  c.ignore_request do |req|
    (req.uri =~ /api\/cat/).nil?
  end
end