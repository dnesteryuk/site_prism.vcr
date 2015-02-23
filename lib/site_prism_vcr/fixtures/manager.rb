module SPV
  class Fixtures
    # Takes cares about inserting and ejecting fixtures
    # from Vcr.
    class Manager
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
          VCR.insert_cassette fixture.name, fixture.options
        end
      end

      # Ejects only fixtures from Vcr which are injected
      # by this instance of the fixtures manager class.
      #
      # @return [void]
      def eject
        inserted_names = @fixtures.map(&:name)

        # TODO: find better way, may be some pull request to the VCR?
        VCR.send(:cassettes).delete_if do |cassette|
          if remove = inserted_names.include?(cassette.name)
            cassette.eject
          end

          remove
        end
      end
    end # class Manager
  end # class Fixtures
end # module SPV
