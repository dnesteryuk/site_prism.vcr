module SPV
  module DSL
    # This class extends SPV::DSL::InitialAdjuster with new methods
    # which can be used in a block for manipulating fixtures before applying them.
    class Adjuster < InitialAdjuster
      def initialize(options, fixtures)
        super options

        @options, @fixtures = options, fixtures
      end

      # Replaces default fixtures with a set of fixtures
      # defined in a block passed while applying fixtures.
      #
      # @return [void]
      #
      # @api public
      def replace
        change_fixtures :replace
      end

      # Joins default fixtures with a set of fixtures
      # defined in a block passed while applying fixtures.
      #
      # @return [void]
      #
      # @api public
      def union
        change_fixtures :union
      end

      # Exchanges certain default fixtures with another fixtures.
      #
      # @param old_fixtures [String, Array<String>] List of fixtures which should be removed.
      #   If string is passed instead of an array, it will be converted to an array.
      # @param new_fixtures [String, Array<String>] List of fixtures which should added.
      #   If string is passed instead of an array, it will be converted to an array.
      #
      # @return [void]
      #
      # @api public
      def exchange(old_fixtures, new_fixtures)
        home_path_modifier = Fixtures::Modifiers::HomePath.new(@options)

        old_fixtures = [old_fixtures] unless old_fixtures.is_a?(Array)
        new_fixtures = [new_fixtures] unless new_fixtures.is_a?(Array)

        old_fixtures, new_fixtures = @fixtures_handler.handle_set_raws(
          old_fixtures,
          new_fixtures,
          [home_path_modifier]
        )

        @fixtures = @fixtures.exchange(
          old_fixtures,
          new_fixtures
        )
      end

      # Redefines default waiter options or if default waiter options is not defined,
      # it defines new options for a waiter. This method doesn't redefine all default options,
      # it redefines only options passed in a hash.
      #
      # @param options [Hash] Options for a waiter
      #
      # @return [void]
      #
      # @api public
      def waiter_options(options)
        @options.merge_waiter_options!(options)
      end

      # Performs the replace action when no explicit action is defined
      # in a block for manipulating fixtures before applying them.
      #
      # @return [SPV::Fixtures] A set of prepared fixtures.
      #
      # @api public
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