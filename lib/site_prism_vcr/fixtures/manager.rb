module SPV
  class Fixtures
    # Takes cares about inserting and ejecting fixtures
    # from Vcr.
    class Manager
      CUSTOM_OPTIONS = [:eject]

      # Initializes a new instance of the fixtures manager class,
      # injects given fixtures into VCR,
      # returns an instance of the fixtures manager class
      #
      # @param fixtures [SPV::Fixtures] List of fixtures.
      # @param options [SPV::Options] An object with all options.
      #
      # @return [SPV::Fixtures::Manager]
      def self.inject(fixtures, options)
        manager = new(fixtures, options)
        manager.inject
        manager
      end

      # Initializes a new instance
      #
      # @param fixtures [SPV::Fixtures] List of fixtures.
      # @param options [SPV::Options] An object with all options.
      #
      # @return [void]
      def initialize(fixtures, options)
        @fixtures, @options = fixtures, options
      end

      # Injects given fixtures to Vcr.
      #
      # @return [void]
      #
      # @raise [ArgumentError] If a list of fixtures is empty.
      def inject
        raise ArgumentError.new(
          'No fixtures were specified to insert them into VCR'
        ) if @fixtures.size == 0

        @fixtures.each do |fixture|
          VCR.insert_cassette fixture.name, fixture.options.select { |k, v| !CUSTOM_OPTIONS.include?(k) }
        end
      end

      # Ejects only fixtures from Vcr which are injected
      # by this instance of the fixtures manager class.
      #
      # @return [void]
      def eject
        cassettes_to_insert = []

        #binding.pry

        while cassette = VCR.eject_cassette
          fixture = @fixtures.find{ |fixture| fixture.name == cassette.name }

          if !fixture || !fixture.options.fetch(:eject, true)
            cassettes_to_insert << cassette
          end
        end

        cassettes_to_insert.reverse.each do |cassette|
          VCR.insert_cassette cassette.name, {
            record:             cassette.record_mode,
            match_requests_on:  cassette.match_requests_on,
            erb:                cassette.erb,
            re_record_interval: cassette.re_record_interval
          }
        end
      end
    end # class Manager
  end # class Fixtures
end # module SPV
