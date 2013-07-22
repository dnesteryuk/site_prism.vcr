module SPV
  class Fixtures
    module Modifiers
      # It takes a fixture and adds a path to it
      class Path
        def initialize(options)
          @options = options
        end

        def modify(fixture)
          path = @options.path
          path = path + '/' unless path[-1, 1] == '/'

          fixture.add_path(path)
        end
      end
    end
  end
end