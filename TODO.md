# TODO

## Release 0.0.1

1. Add comments to code
2. Check documentation about this gem
3. Think about adding more integration tests
4. Add possibility to pass VCR options to cassettes while applying them
5. Refactore code to be able to define modifiers for helper methods (namely for fixtures and path helper methods)

## Release 0.0.2

1. Pages and elements should inherit fixtures defined for their parents
2. Add possibility to add fixtures for existing elements, it will be helpful in case they are inherited
3. Think about applying fixtures for any kind of events, for example, for a change event of select boxes
4. Create possibility to apply fixtures for page loading without visiting a page. It will be very helpful when we don't visit a page directly, but we use a link to do that
5. Think how to manage the situation when a method name and a block is passed to the `waiter` helper method
6. When we eject fixtures from Vcr we should eject only fixtures inserted into Vcr by one specific fixtures manager (See SPV#eject)
7. Make this gem working on JRuby

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

## Thing to think over

1. Should we add the integration tests for page load to make sure 2 HTTP requests will be handled properly?
2. Should we add own integration tests to test the path helper method?
