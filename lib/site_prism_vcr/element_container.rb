module SitePrism::ElementContainer
  def element_with_vcr(element_name, selector, *args, &block)
    options = args.delete_at(-1) || {}

    element element_name, selector

    origin_element_name = "origin_#{element_name}"

    alias_method origin_element_name, element_name

    define_method element_name.to_s do
      elem = public_send(origin_element_name)

      SitePrism::Vcr::Element.new(elem, self, options, &block)
    end
  end
end