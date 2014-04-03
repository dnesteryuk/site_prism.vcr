require 'pathname'
require_relative 'base'

module SPV
  class Fixtures
    module Modifiers
      # It allows to move up through a hierarchy of directories.
      #
      # Example:
      #  ~/../some_fixture
      #
      class RelativePath < Base
        def modify(fixture)
          path = Pathname.new(fixture.name)

          fixture.path = path.cleanpath.to_path
        end
      end
    end
  end
end