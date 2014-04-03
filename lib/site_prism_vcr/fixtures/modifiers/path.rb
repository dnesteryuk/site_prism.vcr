require_relative 'base'

module SPV
  class Fixtures
    module Modifiers
      # It takes a fixture and adds a path to it.
      class Path < Base
        def modify(fixture)
          if fixture.has_link_to_home_path?
            raise HomePathError.new(
              "You cannot use the home path while listing fixtures in the 'path' method. " <<
              "Please, use 'fixtures' method for '#{fixture.clean_name}' fixture or " <<
              "you can additionally use the 'path' method where you will specify a home path as a path name." <<
              "Example: path('~/', ['#{fixture.clean_name}'])"
            )
          else
            path = @options.path
            path = path + '/' unless path[-1, 1] == '/'

            fixture.path = @options.path
          end
        end

        class HomePathError < ArgumentError; end
      end
    end
  end
end