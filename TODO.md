# TODO

## Release 0.1.1

1. Think how to avoid monkey patching to add stuffs to SitePrism
2. We should freeze an instance of SPV::Fixtures to make sure it is not mutable, otherwise, there may be situation when default fixtures will be corrupted.
3. We should disable double defining actions in the adjusting block:

  ```ruby
    self.some_link.click_and_apply_vcr do
      fixtures ['test', 'test2']
      union
      fixtures ['test3']
      replace
    end
  ```
It will lead to mess since the last fixture will replace all other fixtures. Union action can be used with exchange, but it should be disabled for using with replace.
4. Change code to use DI with build (http://solnic.eu/2013/12/17/the-world-needs-another-post-about-dependency-injection-in-ruby.html)
5. Start using https://roadchange.com/

## Release 0.2.0

1. Pages and elements should inherit fixtures defined for their parents
2. When we eject fixtures from Vcr we should eject only fixtures inserted into Vcr by one specific fixtures manager (See SPV#eject)
3. Make this gem working on JRuby (since we eject all VCR cassettes, it may be not thread safe)
4. Think about creating set of fixtures which can be exchanged by a name of set. It will be very helpful when you have to exchange a set of fixtures.

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
6. Think about renaming current integration tests on acceptance tests and create new integration tests which will test integration between classes without involving a browser. It will solve a lot of issues with shared tests to check the same things for pages and elements. In acceptance tests we will test very basic stuffs.

