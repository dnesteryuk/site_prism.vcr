module SPV
  module DSL
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
        home_path_modifier = Fixtures::Modifiers::HomePath.new(@options)

        old_fixtures = @fixtures_converter.convert_raw([*old_fixtures])
        new_fixtures = @fixtures_converter.convert_raw([*new_fixtures])

        old_fixtures.each do |fixture|
          home_path_modifier.modify(fixture)
        end

        new_fixtures.each do |fixture|
          home_path_modifier.modify(fixture)
        end

        @fixtures = @fixtures.exchange(
          old_fixtures,
          new_fixtures
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
          @fixtures = @fixtures.public_send(action, @tmp_keeper.fixtures)
          @tmp_keeper.clean_fixtures
          @is_action_done = true
        end
    end # class Adjuster
  end # module DSL
end # module SPV