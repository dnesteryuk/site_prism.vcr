# TODO: write tests for this code
module SitePrism::ElementContainer
  def element_with_vcr(element_name, selector, *args)
    # TODO: it should raise an error if the last argument is not hash
    # TODO: it should raise an error if the options hash doesn't containt fixtures
    # TODO: the fixtures may be added afterwards
    if args.length > 0
      options = args.delete_at(-1)
    end

    element element_name, selector, *args

    origin_element_name = "origin_#{element_name}"

    alias_method origin_element_name, element_name

    define_method element_name.to_s do
      elem = send(origin_element_name)

      SitePrism::Vcr::Element.new(elem, options || {})
    end
  end
end