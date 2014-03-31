module SPV
  class Fixtures
    module Modifiers
      # It takes a fixture and replaces "~/" with
      # a defined home path.
      class HomePath
        def initialize(options)
          @options = options
        end

        def modify(fixture)
          if fixture.has_link_to_home_path?
            if @options.home_path
              fixture.set_home_path(@options.home_path)
            else
              raise ArgumentError.new(
                "You are trying to use a home path for #{fixture.name} fixture. " \
                "Home path cannot be used since it is not defined, please refer to the documentation " \
                "to make sure you define the home path properly."
              )
            end
          end
        end
      end
    end
  end
end