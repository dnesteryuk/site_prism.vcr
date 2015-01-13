# 0.2.0 (Not released yet)

  * fixed code for ejecting fixtures from Vcr. Now SitePrism.Vcr ejects only fixtures we are injected by itself, any other fixtures which are injected outside of this library won't be touched.
  * added a new functionality to alter default fixtures defined in a parent class page. Now if additional fixtures should be added to a default fixtures list, it can be done with `adjust_parent_vcr_options`. Waiter can be replaced as well.

  ```ruby
    class BasePage < SitePrism::Page
      vcr_options_for_load do
        fixtures ['cars', 'products']

        waiter &:wait_for_cars_list
      end
    end

    class CarsPage < BasePage
      adjust_parent_vcr_options do
        fixtures ['features']

        waiter &:wait_for_cars_and_features_list

        union # if it is omitted, the fixtures list defined in this block will
        # replace the fixtures list defined in the parent page class
      end
    end
  ```

# 0.1.2

  * fixed the issue with storing a fixture into a correct sub directory if it is provided along with a fixture name (It happened only for `path` helper method which used with a home path symbol).

# 0.1.1

  * fixed the issue with using replace and union actions in one block.

  ```ruby
    self.some_link.click_and_apply_vcr do
      fixtures ['test', 'test2']
      union
      fixtures ['test3']
      replace
    end
  ```

  In some cases it may have leaded to unexpected behavior.
  * internal improvements
  * upgraded dependencies. Now gem depends on Vcr 2.9.2 and SitePrism 2.6.
  * added possibility to use relative path with a home path.

  ```ruby
    self.some_link.click_and_apply_vcr do
      home_path 'custom'

      fixtures ['~/../test'] # '~' indicates a home path which is defined above in this block
    end
  ```

# 0.1.0

  * upgraded dependencies. Now gem depends on Vcr 2.8.0 and SitePrism 2.5.
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
