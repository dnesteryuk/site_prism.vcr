# TODO

## Release 0.1.3

1. Think how to avoid monkey patching to add stuffs to SitePrism
2. Change code to use DI with build (http://solnic.eu/2013/12/17/the-world-needs-another-post-about-dependency-injection-in-ruby.html)
3. Add possibility to define any shortcuts for paths similar to the home path.
4. Change text: `You are trying to use a home path for ~/more_storages fixture. Home path cannot be used since it is not defined, please refer to the documentation to make sure you define the home path properly`. It sounds weird.

## Release 0.2.0

1. Pages and elements should inherit fixtures defined for their parents
2. Make this gem working on JRuby (since we eject all VCR cassettes, it may be not thread safe)
3. Think about creating set of fixtures which can be exchanged by a name of set. It will be very helpful when you have to exchange a set of fixtures.
4. Add code to not remove one specific cassete from VCR

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
5. Think about renaming current integration tests on acceptance tests and create new integration tests which will test integration between classes without involving a browser. It will solve a lot of issues with shared tests to check the same things for pages and elements. In acceptance tests we will test very basic stuffs.
6. May be SPV::Fixtures::TmpKeeper is redundant and SPV::Fixtures can be used as a tmp keeper of fixtures?


