module SitePrism
  module Vcr
    # This class is a container for keeping all prepared fixtures for inserting
    # into VCR.
    # TODO: it should allow to do only actions like: union, replace
    class Fixtures < Set
      def exchange(old_vals, new_vals)
        new_fixtures = union(new_vals)
        new_fixtures.subtract(old_vals)
      end

      def replace(vals)
        if vals.size > 0
          self.class.new(vals)
        else
          self
        end
      end
    end
  end
end