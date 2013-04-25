# TODO: it should allow to do only actions like: union, replace
module SitePrism
  module Vcr
    class Fixtures < Set
      def exchange(old_vals, new_vals)
        subtract(old_vals).merge(new_vals)
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