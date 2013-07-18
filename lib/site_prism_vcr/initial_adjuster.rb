module SPV
  # This class provides DSL which is used while defining fixtures
  # and applying them.
  class InitialAdjuster
    def initialize(options)
      @options = options
      @fixtures_handler = FixturesHandler.new(@options)
    end

    # Defines fixtures which will be inserted into VCR.
    #
    # @param list [Array<String>] List of fixtures.
    #
    # @return [void]
    #
    # @api public
    def fixtures(list)
      @fixtures_handler.add_fixtures(list)
    end

    # Defines path to fixtures. Later this path
    # can be used for defining fixtures. It is especially
    # useful when you use deep subdirectories structure for storing fixtures.
    #
    # @param path [String] Path to fixtures.
    #
    # @return [void]
    #
    # @api public
    def home_path(path)
      @options.home_path = path
    end

    # Applies a given path to list of fixtures and defines
    # those fixtures to be inserted into VCR.
    #
    # @param path [String] Path to fixtures.
    # @param fixture_names [Array<String>] List of fixtures,
    #
    # @return [void]
    #
    # @raise [ArgumentError] If any of fixture names has path to a home directory.
    #
    # @api public
    def path(path, fixture_names)
      fixtures, wrong_fixtures = [], []

      fixture_names.map do |name|
        if name[0..1] == '~/'
          wrong_fixtures << name[2..-1]
        else
          fixture_with_path = path.dup
          fixture_with_path << '/' unless path[-1, 1] == '/'
          fixture_with_path << name

          fixtures << fixture_with_path
        end
      end

      if wrong_fixtures.length > 0
        prepared_names = wrong_fixtures.join("', '")

        raise ArgumentError.new(
          "You cannot use the home path while listing fixtures in the 'path' method. " <<
          "Please, use 'fixtures' method for '#{wrong_fixtures.join(', ')}' fixtures or " <<
          "you can additionally use the 'path' method where you will specify a home path as a path name." <<
          "Example: path('~/', ['#{prepared_names}'])"
        )
      end

      @fixtures_handler.add_fixtures(fixtures)
    end

    # Defines a waiter which will be used for waiting until all HTTP
    # interactions have finished.
    #
    # @param options [Hash, nil] Options which allows to change behavior of a waiter.
    #   this method should be defined directly in a section
    #   or a page where fixtures are defined for an element.
    # @option options :eject_cassettes [Boolean] Whether or not to eject
    #   all cassettes from VCR once a waiter has finished his work.
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

    def prepared_fixtures
      Fixtures.new(@fixtures_handler.fixtures)
    end
  end # class InitialAdjuster
end # module SPV