# TODO

1. Create possibility to define fixtures without the click action:

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

2. There should be possibility to change default fixtures:

    ```ruby
    self.confirm_btn.vcr do
      path 'products', ['tomato', 'fruit/apple']
      path 'goods', 'cars'

      force_replace
    end
    ```

3. Add documentation into Readme file about waiters and exchange option
4. Add comments to code
5. Think about adding more integration tests
6. Think about this case

    ```ruby
    self.confirm_btn.click_and_apply_vcr do
      path 'some/path', ['test', '~/test2']
    end
    ```
7. Make sure there is an integration test to make sure the path and fixtures are used together while describing an element with vcr
8. Think about this case:

    ```ruby
    self.confirm_btn.click_and_apply_vcr(['custom/fixtures']) do
      path 'some/path', ['test', '~/test2']
    end
    ```
9. Make this gem working on JRuby
10. Add possibility to pass VCR options to cassettes while applying them
11. Pages and elements should inherit fixtures defined for their parents
