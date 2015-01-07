require_relative 'base'

module SPV
  class Fixtures
    module Modifiers
      # It takes a fixture and replaces "~/" with
      # a defined home path.
      class HomePath < Base
        def modify(fixture)
          if fixture.has_link_to_home_path?
            if @options.home_path
              fixture.set_home_path(@options.home_path)
            else
              raise ArgumentError.new(
                "Home path is not defined, hence the path to \"#{fixture.name}\" cannot be identified."
              )
            end
          end
        end
      end
    end
  end
end