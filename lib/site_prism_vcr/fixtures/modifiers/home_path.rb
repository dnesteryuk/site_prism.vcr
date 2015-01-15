require_relative 'base'

module SPV
  class Fixtures
    module Modifiers
      # It takes a fixture and replaces "~/" with
      # a defined home path.
      class HomePath < Base
        def modify(fixture)
          if shortcut = fixture.shortcut_path
            if path = @options.shortcut_path(shortcut)
              fixture.set_home_path(path)
            else
              raise ArgumentError.new(
                "You are trying to use the '#{shortcut}' shortcut path for #{fixture.name} fixture. " \
                "This shortcut path cannot be used since it is not defined, please refer to the documentation " \
                "to make sure you properly define the shortcut path."
              )
            end
          end
        end
      end
    end
  end
end