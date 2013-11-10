# Version 0.1.0

## Changed

  * updated dependencies. Now gem depends on Vcr 2.7.0 and SitePrism 2.5.
  * re-factored the way how Vcr cassettes could be applying for any event of a page.
    Before that change we had to use ugly way:

  ```ruby
    @cars.apply_vcr(-> { page.find('#cars').click }) do
      fixtures ['cars']
    end
  ```
  
  Now we use changeable way for this purpose:
  
  ```ruby
    @cars = CarsPage.new
  
    @cars.shift_event {
      page.find('#cars').click
    }.apply_vcr do
      fixtures ['cars']
    end
  ```

## Added

  * added possibility to apply Vcr cassettes for any event of an element. [Roman Rott and Dmitriy Nesteryuk]

  ```ruby
  @products_page.cars_dropdown.shift_event{
    set 'Ford'
  }.apply_vcr do
    fixtures ['cars/ford/prices']
  end
  ```
