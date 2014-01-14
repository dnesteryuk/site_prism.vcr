require 'spec_helper'

require 'capybara/rspec'
require 'capybara/firebug'

require 'support/test_app/test_app'

Dir["./spec/support/shared/integration/**/*.rb"].sort.each {|f| require f }
Dir["./spec/support/site_prism/pages/**/*.rb"].sort.each {|f| require f }

# TODO: move this method to sime file
def find_available_port
  server = TCPServer.new('127.0.0.1', 0)
  server.addr[1]
ensure
  server.close if server
end

Capybara.app = TestApp
Capybara.default_driver = :selenium
HTTPI.log = false

Selenium::WebDriver::Firefox::Profile.firebug_version = '1.11.0'

Capybara.server_port = find_available_port

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