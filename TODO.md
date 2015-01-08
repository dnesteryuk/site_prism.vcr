# TODO

## Release 0.2.0

1. Think how to avoid monkey patching to add stuffs to SitePrism.
2. Change code to use DI with build (http://solnic.eu/2013/12/17/the-world-needs-another-post-about-dependency-injection-in-ruby.html).
3. Add possibility to define any shortcuts for paths similar to the home path.
4. Write tutorial how to record new interactions with SitePrism.Vcr.

## Release 0.3.0

1. Make this gem working on JRuby (since we eject all VCR cassettes, it may be not thread safe)
2. Think about creating set of fixtures which can be exchanged by a name of set. It will be very helpful when you have to exchange a set of fixtures.
3. Add code to not remove one specific cassete from VCR
4. Find better names for `vcr_options_for_load` and `adjust_parent_vcr_options` methods.

## Things to think over

1. Should we add the integration tests for page load to make sure 2 HTTP requests will be handled properly?
2. Should we add own integration tests to test the path helper method?
3. Should we add a test for testing to HTTP requests on page load?
4. Should be Options class immutable?
5. Think about renaming current integration tests on acceptance tests and create new integration tests which will test integration between classes without involving a browser. It will solve a lot of issues with shared tests to check the same things for pages and elements. In acceptance tests we will test very basic stuffs.
6. May be SPV::Fixtures::TmpKeeper is redundant and SPV::Fixtures can be used as a tmp keeper of fixtures?
7. Elements should inherit fixtures defined for their parents
8. Create possibility to define fixtures without the click action (it can be done with `alter_fixtures` method from the applier, but it is not accessible outside of the applier):

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