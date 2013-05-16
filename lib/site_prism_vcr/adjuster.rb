# TODO: create possibility to exchange fixtures
module SitePrism
  module Vcr
    class Adjuster < InitialAdjuster
      def initialize(options, fixtures)
        @options, @fixtures = options, fixtures
      end

      def waiter(waiter_method)
        @options.waiter = waiter_method
      end

      def replace
        change_fixtures :replace
      end

      def union
        change_fixtures :union
      end

      def exchange(old_fixtures, new_fixtures)
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
          @fixtures = @fixtures.public_send(action, @options.fixtures)
          @options.clean_fixtures
          @is_action_done = true
        end
    end
  end
end