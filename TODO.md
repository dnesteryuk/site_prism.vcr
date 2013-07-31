# TODO

## Release 0.0.1

1. Add comments to code
2. Check documentation about this gem
3. Think about adding more integration tests
4. Add possibility to pass VCR options to cassettes while applying them
5. Remove tests stubbing VCR methods
6. Think about adding the integration test when we use the exchange method with ERB variables
7. There is a bug with:

  @products.load_and_apply_vcr do
    exchange '~/cars', {fixture: '~/cars', options: {erb: {name: 'Ford'}}
  end


## Release 0.0.2

1. Pages and elements should inherit fixtures defined for their parents
2. Add possibility to add fixtures for existing elements, it will be helpful in case they are inherited
3. Think about applying fixtures for any kind of events, for example, for a change event of select boxes
4. Think how to manage the situation when a method name and a block is passed to the `waiter` helper method
5. When we eject fixtures from Vcr we should eject only fixtures inserted into Vcr by one specific fixtures manager (See SPV#eject)
6. Make this gem working on JRuby

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
