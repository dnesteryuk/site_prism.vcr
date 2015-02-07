module SPV
  module Mixins
    module Element
      def element_with_vcr(element_name, *args, &block)
        element element_name, *args

        link_vcr_with_element(element_name, &block)
      end

      def link_vcr_with_element(element_name, &block)
        origin_element_name = "origin_#{element_name}"

        alias_method origin_element_name, element_name

        define_method element_name.to_s do
          elem = public_send(origin_element_name)

          SPV::Element.new(elem, self, &block)
        end
      end
    end
  end
end