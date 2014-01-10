# 0.1.0

  * changed dependencies. Now gem depends on Vcr 2.8.0 and SitePrism 2.5.
  * BREAKING CHANGE: re-factored the way how Vcr cassettes could be applying for any event of a page.
    Before that change we had to use ugly way

  ```ruby
    @cars.apply_vcr(-> { page.find('#cars').click }) do
      fixtures ['cars']
    end
  ```

  now we use chainable way for this purpose

  ```ruby
    @cars = CarsPage.new

    @cars.shift_event {
      page.find('#cars').click
    }.apply_vcr do
      fixtures ['cars']
    end
  ```

  * fixed the issue with defining an action to be done over cassettes in the adjusting block. Now even if an action is defined before a list of cassettes, the adjusting block will be performed properly

  ```ruby
    @products_page.cars_dropdown.click_and_apply_vcr do
      replace
      fixtures ['cars/ford/prices']
    end
  ```

  * added possibility to apply Vcr cassettes for any event of an element. [Roman Rott and Dmitriy Nesteryuk]

  ```ruby
    @products_page.cars_dropdown.shift_event{
      set 'Ford'
    }.apply_vcr do
      fixtures ['cars/ford/prices']
    end
  ```

  * added possibility to link Vcr with already defined elements, it will be helpful in case they are inherited

  ```ruby
    class CarsPage < TransportPage
      link_vcr_with_element :transport_details_link do
        fixtures ['cars/ford']
      end
    end

    @page = CarsPage.new
    @page.transport_details_link.click_and_apply_vcr
  ```

  * added possibility to redefine default options for a default waiter

  ```ruby
    class ProductsPage < SitePrism::Page
      link_vcr_with_element :details_link do
        fixtures ['cars/ford']

        waiter(eject_cassettes: false) { self.wait_until_loading_indicator_invisible } # default waiter with options
      end
    end

    @page = ProductsPage.new
    @page.details_link.click_and_apply_vcr do
      waiter_options(eject_cassettes: true) # redefines default options
    end
  ```