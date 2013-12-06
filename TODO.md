# TODO

## Release 0.1.0

1. Recheck integration tests for waiters
2. The way how we do actions (replace, union etc) in adjuster is ugly. We should do something with `prepared_fixtures` method. We should find better way for performing a default action. There may be even a bug since the default action may not be performed:

  ```ruby
    self.some_link.click_and_apply_vcr do
      fixtures ['test', 'test2']
      union
      fixtures ['test3']
    end
  ```
The last fixture will be lost due to a simple mistake in ordering.
3. Change integration tests to use real data.

## Release 0.1.1

1. Pages and elements should inherit fixtures defined for their parents
2. When we eject fixtures from Vcr we should eject only fixtures inserted into Vcr by one specific fixtures manager (See SPV#eject)
3. Think about creating set of fixtures which can be exchanged by a name of set. It will be very helpful when you have to exchange a set of fixtures.
4. Think how to avoid monkey patching to add stuffs to SitePrism
5. Make this gem working on JRuby (since we eject all VCR cassettes, it may be not thread safe)
6. SPV::Applier#apply_vcr should be refactored, it is too complex

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


## Things to think over

1. Should we add the integration tests for page load to make sure 2 HTTP requests will be handled properly?
2. Should we add own integration tests to test the path helper method?
3. Should we add a test for testing to HTTP requests on page load?
4. Should be Options class immutable?
5. May be it makes sense to separately keep path from the name of a fixture? See SPV::Fixture class

