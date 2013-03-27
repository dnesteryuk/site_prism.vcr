# TODO: it should allow to do only actions like: union, replace
module SitePrism
  module Vcr
    class Fixtures < Set
      def exchange(old_vals, new_vals)
        subtract(old_vals).merge(new_vals)
      end
    end
  end
end