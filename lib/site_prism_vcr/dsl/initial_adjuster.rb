module SPV
  module DSL
    # This class provides DSL which is used while defining fixtures
    # and applying them.
    class InitialAdjuster
      def initialize(options)
        @options          = options
        @tmp_keeper       = Fixtures::TmpKeeper.new(@options)
        @fixtures_handler = Fixtures::Handler.new(@options)
      end

      # Defines fixtures which will be inserted into VCR.
      #
      # @param list [Array<String>] List of fixtures.
      #
      # @return [void]
      #
      # @api public
      def fixtures(list)
        prepared_fixtures = @fixtures_handler.handle_raw(
          list,
          [
            Fixtures::Modifiers::HomePath.new(@options),
            Fixtures::Modifiers::RelativePath.new(@options)
          ]
        )

        @tmp_keeper.add_fixtures(prepared_fixtures)
      end

      # Defines a home path to fixtures. Later this path
      # can be used for defining fixtures.
      #
      # Example:
      #   home_path 'cassettes/cars/ford'
      #   fixtures['~/car']
      #
      # @param path [String] Path to fixtures.
      #
      # @return [void]
      #
      # @api public
      def home_path(path)
        @options.add_shortcut_path('~', path)
      end

      # Defines a shortcut path to fixtures. Later this path
      # can be used for defining fixtures.
      #
      # Example:
      #   shortcut_path 'ford', 'cassettes/cars/ford'
      #   fixtures[':ford/car']
      #
      # @param name [String] Shortcut name to be used while defining a path to fixtures..
      # @param path [String] Path to fixtures.
      #
      # @return [void]
      #
      # @api public
      def shortcut_path(name, path)
        @options.add_shortcut_path(name, path)
      end

      # Applies a given path to list of fixtures and defines
      # those fixtures to be inserted into VCR.
      #
      # @param path [String] Path to fixtures.
      # @param fixture_names [Array<String>] List of fixtures.
      #
      # @return [void]
      #
      # @raise [ArgumentError] If any of fixture names has path to a home directory.
      #
      # @api public
      def path(path, fixture_names)
        options_with_path  = OptionsWithPath.new(@options)
        options_with_path.path = path

        path_modifier      = Fixtures::Modifiers::Path.new(options_with_path)
        home_path_modifier = Fixtures::Modifiers::HomePath.new(options_with_path)

        prepared_fixtures = @fixtures_handler.handle_raw(
          fixture_names,
          [
            path_modifier,
            home_path_modifier
          ]
        )

        @tmp_keeper.add_fixtures(prepared_fixtures)
      end

      # Defines a waiter which will be used for waiting until all HTTP
      # interactions have finished.
      #
      # @param options [Hash, nil] Options which allows to change behavior of a waiter.
      # @option options :eject_cassettes [Boolean] Whether or not to eject
      #   all cassettes from VCR once a waiter meets an expectation.
      #
      # @yield Block to be used as a waiter.
      #
      # @return [void]
      #
      # @api public
      def waiter(waiter_options = nil, &block)
        @options.waiter         = block
        @options.waiter_options = waiter_options
      end

      # Returns set of prepared fixtures.
      #
      # @return [SPV::Fixtures] A set of prepared fixtures.
      #
      # @api public
      def prepare_fixtures
        Fixtures.new(@tmp_keeper.fixtures)
      end
    end # class InitialAdjuster
  end # module DSL
end # module SPV