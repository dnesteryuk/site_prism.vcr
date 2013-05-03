module SitePrism::ElementContainer
  def element_with_vcr(element_name, selector, *args, &block)
    options = args.delete_at(-1) || {}

    element element_name, selector

    origin_element_name = "origin_#{element_name}"

    alias_method origin_element_name, element_name

    define_method element_name.to_s do
      elem = public_send(origin_element_name)

      parent = if respond_to?(:parent)
        self.parent
      else
        self
      end

      SitePrism::Vcr::Element.new(elem, parent, options, &block)
    end
  end
end