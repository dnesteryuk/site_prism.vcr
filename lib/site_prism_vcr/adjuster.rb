module SPV
  class Adjuster < InitialAdjuster
    def initialize(options, fixtures)
      super options

      @options, @fixtures = options, fixtures
    end

    def replace
      change_fixtures :replace
    end

    def union
      change_fixtures :union
    end

    def exchange(old_fixtures, new_fixtures)
      @fixtures = @fixtures.exchange(
        @fixtures_handler.fixtures([*old_fixtures]),
        @fixtures_handler.fixtures([*new_fixtures])
      )
    end

    def prepared_fixtures
      # If no action has been performed,
      # it should be performed manually, before allowing
      # to get prepared fixtures.
      replace unless @is_action_done
      @fixtures
    end

    private
      def change_fixtures(action)
        @fixtures = @fixtures.public_send(action, @fixtures_handler.fixtures)
        @fixtures_handler.clean_fixtures
        @is_action_done = true
      end
  end
end