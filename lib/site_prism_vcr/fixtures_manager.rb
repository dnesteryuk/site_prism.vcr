module SPV
  # Takes cares about inserting and ejecting fixtures
  # from Vcr.
  class FixturesManager
    def initialize(options)
      @options = options
    end

    # Injects given fixtures for Vcr.
    #
    # @param fixtures [Array] List of fixtures.
    #
    # @return [void]
    #
    # @raise [ArgumentError] If a list with fixtures is empty.
    def inject(fixtures)
      raise ArgumentError.new(
        'No fixtures were specified to insert them into VCR'
      ) if fixtures.size == 0

      fixtures.map do |fixture|
        VCR.insert_cassette fixture
      end
    end

    # Ejects all fixtures from Vcr.
    # Now it doesn't care which fixtures were inserted by
    # an instance of this class. After calling this method
    # Vcr will have no inserted fixtures at all.
    #
    # @return [void]
    def eject
      SPV::Helpers.eject_all_cassettes
    end
  end
end
