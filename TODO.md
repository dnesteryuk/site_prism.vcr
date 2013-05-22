# TODO

1. Create possibility to define a waiter with a block:

    ```ruby
    element_with_vcr \
      :link_with_one_request_and_delay,
      '#link_with_one_request_and_delay',
      fixtures: ['octocat']
      waiter:   { self.wait_until_loading_indicator_invisible and self.wait_for_products }
    ```

2. Create possibility to define fixtures without the click action:

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

3. There should be possibility to change default fixtures:

    ```ruby
    self.confirm_btn.vcr do
      path 'products', ['tomato', 'fruit/apple']
      path 'goods', 'cars'

      force_replace
    end
    ```

4. Think about removing all fixtures from VCR when fixtures are applied for a click event
5. Add documentation into Readme file about waiters
6. Add comments to code
7. Think about adding more integration tests
8. Think about this case

    ```ruby
    self.confirm_btn.click_and_apply_vcr do
      path 'some/path', ['test', '~/test2']
    end
    ```
9. Make sure there is an integration test to make sure the path and fixtures are used together while describing an element with vcr
10. Think about this case:

    ```ruby
    self.confirm_btn.click_and_apply_vcr(['custom/fixtures']) do
      path 'some/path', ['test', '~/test2']
    end
    ```
11. Make this gem working on JRuby and Ruby 2.0.0