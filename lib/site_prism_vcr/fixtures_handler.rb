# TODO: this class should be splitted onto 2 since it takes care about
# 2 responsibilities
module SPV
  # This class is responsible for keeping a list
  # of prepared fixtures which will be inserted to Vcr
  class FixturesHandler
    attr_reader :fixtures

    def initialize(options)
      @fixtures, @options = [], options
    end

    # TODO: this code should not live here,
    # it violates SPR. Actually, for such thing we have to think over
    # modifier Each fixture should pass through modifiers. Such approach will
    # allow anything with fixtures.
    def fixtures(raw_fixtures = nil)
      wrong_fixtures = []

      raw_fixtures ||= @fixtures

      raw_fixtures.each do |fixture|
        if fixture.has_link_to_home_path?
          if @options.home_path
            fixture.set_home_path(@options.home_path)
          else
            wrong_fixtures << fixture
          end
        end

        fixture
      end

      if wrong_fixtures.size > 0
        raise ArgumentError.new(
          "You are trying to use a home path for these: #{wrong_fixtures.map(&:name).join(', ')} fixtures. " \
          "They cannot be used since the home_path is not defined, please refer to the documentation " \
          "to make sure you define the home path properly."
        )
      else
        raw_fixtures
      end
    end

    def clean_fixtures
      @fixtures = []
    end

    def add_fixtures(new_fixtures)
      @fixtures.concat(new_fixtures)
    end
  end
end
