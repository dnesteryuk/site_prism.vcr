# TODO

1. Create possibility to define a waiter with a block:

    ```ruby
    element_with_vcr \
      :link_with_one_request_and_delay,
      '#link_with_one_request_and_delay',
      fixtures: ['octocat']
      waiter:   { self.wait_until_loading_indicator_invisible and self.wait_for_products }
    ```

2. Create possibility to redefine waiter with a block when a click action is done:

    ```ruby
    self.confirm_btn.click_and_apply_vcr do
      waiter { self.wait_for_sidebar }
    end
    ```

3. Create possibility to define fixtures without the click action:

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

4. There should be possibility to change default fixtures:

    ```ruby
    self.confirm_btn.vcr do
      path 'products', ['tomato', 'fruit/apple']
      path 'goods', 'cars'

      force_replace
    end
    ```

5. Think about removing all fixtures from VCR when fixtures are applied for a click event
6. Add documentation into Readme file about waiters
7. Add comments to code
9. Add possibility to exchange fixtures while using advanced DSL
10. Think about adding more integration tests
11. Think about this case

    ```ruby
    self.confirm_btn.click_and_apply_vcr do
      path 'some/path', ['test', '~/test2']
    end
    ```
12. Make sure there is an integration test to make sure the path and fixtures are used together while describing an element with vcr
13. Think about this case:

    ```ruby
    self.confirm_btn.click_and_apply_vcr(['custom/fixtures']) do
      path 'some/path', ['test', '~/test2']
    end
    ```
14. Make this gem working on JRuby and Ruby 2.0.0