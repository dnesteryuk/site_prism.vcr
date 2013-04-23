module VcrHelper
  # TODO: do pull request to VCR to avoit this thing here
  def eject_fixtures
    while VCR.eject_cassette
    end
  end
end