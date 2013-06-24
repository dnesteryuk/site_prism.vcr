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
12. Think about making more clean fixtures
13. Add ``eject_all_cassettes`` method to Vcr
14. Add integration tests to prove that hash can be used for a defining cassettes for pages.
15. Add possibility to add fixtures for existing elements, it will be helpful in case they are inherited.
16. Think about applying fixtures for any kind of events, for example, for change event of select boxes
17. Add support of this thing:

    ```ruby
    @cars.load_and_apply_vcr do
      exchange 'new', 'used'
    end
    ```

18. Create possibility to apply fixtures for page loading without visiting a page. It will be very helpful when we don't visit a page directly, but we use a link for it
