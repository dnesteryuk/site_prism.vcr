# TODO

## Release 0.0.1

1. Add comments to code and review existing comments.

## Release 0.0.2

1. Think about adding more integration tests
2. Pages and elements should inherit fixtures defined for their parents
3. Add possibility to add fixtures for existing elements, it will be helpful in case they are inherited
4. Think about applying fixtures for any kind of events, for example, for a change event of select boxes
5. Think how to manage the situation when a method name and a block is passed to the `waiter` helper method
6. When we eject fixtures from Vcr we should eject only fixtures inserted into Vcr by one specific fixtures manager (See SPV#eject)
7. Make this gem working on JRuby
8. Give possibility to define options for a waiter instead of redefining a whole waiter in a subclass
9. Turn this code:

```ruby
@cars.apply_vcr(-> { page.find('#cars').click }) do
  fixtures ['cars']
end
```

into

```ruby
@cars.shift_event{ page.find('#cars').click }.apply_vcr do
  fixtures ['cars']
end
```

10. Think about creating set of fixtures which can be exchanged by a name of set. It will be very helpful when you have to exchange a set of fixtures.
11. Think how to avoid monkey patching to add stuffs to SitePrism

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

## Things to think over

1. Should we add the integration tests for page load to make sure 2 HTTP requests will be handled properly?
2. Should we add own integration tests to test the path helper method?
