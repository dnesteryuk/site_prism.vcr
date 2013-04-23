# TODO

1. Add possibility to define a fixture without path while using advanced DSL

2. Create possibility to define a waiter:

    ```ruby
    element_with_vcr \
      :link_with_one_request_and_delay,
      '#link_with_one_request_and_delay',
      fixtures: ['octocat']
      waiter:   { self.wait_until_loading_indicator_invisible and self.wait_for_products }
    ```

3. Create possibility to redefine waiter when a click action is done:

    ```ruby
    self.confirm_btn.click_and_apply_vcr do
      waiter { self.wait_for_sidebar }
    end
    ```

4. Create possibility to define fixtures without the click action:

    ```ruby
    self.confirm_btn.vcr do
      path 'products', ['tomato', 'fruit/apple']
      path 'goods', 'cars'

      replace
    end
    ```

  and then

    ```ruby
    self.confirm_btn.click_and_apply_vcr
    ```

  will use previusly defined fixtures

5. There should be possibility to change default fixtures:

    ```ruby
    self.confirm_btn.vcr do
      path 'products', ['tomato', 'fruit/apple']
      path 'goods', 'cars'

      force_replace
    end
    ```

6. Think about removing all fixtures from VCR when fixtures are applied for a click event
7. Add documentation into Readme file
8. Add comments to code
