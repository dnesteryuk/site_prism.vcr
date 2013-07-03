# TODO

## Release 0.0.1

1. Think about this case:

    ```ruby
    self.confirm_btn.click_and_apply_vcr(['custom/fixtures']) do
      path 'some/path', ['test', '~/test2']
    end

    ```
2. Add comments to code
3. Check documentation about this gem
4. Make this gem working on JRuby
5. Think about making more clean fixtures
6. Think about adding more integration tests

## Release 0.0.2

1. Add possibility to pass VCR options to cassettes while applying them
2. Pages and elements should inherit fixtures defined for their parents
3. Add possibility to add fixtures for existing elements, it will be helpful in case they are inherited
4. Think about applying fixtures for any kind of events, for example, for a change event of select boxes
5. Create possibility to apply fixtures for page loading without visiting a page. It will be very helpful when we don't visit a page directly, but we use a link to do that

## Should be implemented?

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

  will use previously defined fixtures

2. There should be possibility to change default fixtures:

    ```ruby
    self.confirm_btn.vcr do
      path 'products', ['tomato', 'fruit/apple']
      path 'goods', 'cars'

      force_replace
    end
    ```