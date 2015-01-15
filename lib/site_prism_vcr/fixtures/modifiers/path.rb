require_relative 'base'

module SPV
  class Fixtures
    module Modifiers
      # It takes a fixture and adds a path to it.
      class Path < Base
        def modify(fixture)
          if shortcut = fixture.shortcut_path
            raise ShortcutPathError.new(
              "You cannot use a shortcut path while listing fixtures in the 'path' method. " <<
              "Please, use 'fixtures' method for '#{fixture.clean_name}' fixture or " <<
              "you can additionally use the 'path' method where you will specify a shortcut path as a path name." <<
              "Example: path(':#{shortcut}', ['#{fixture.clean_name}'])"
            )
          else
            path = @options.path
            path = path + '/' unless path[-1, 1] == '/'

            fixture.prepend_path(path)
          end
        end

        class ShortcutPathError < ArgumentError; end
      end
    end
  end
end