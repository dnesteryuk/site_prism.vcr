# TODO

1. The *replace* action for fixtures should be default.
2. Create DSL which will support following:

    self.confirm_btn.click_and_apply_vcr do
      path 'products', ['tomato', 'fruit/apple']
      path 'goods', 'cars'

      replace
    end

3. Create possibility to define a waitor:

    element_with_vcr \
      :link_with_one_request_and_delay,
      '#link_with_one_request_and_delay',
      fixtures: ['octocat']
      waiter: :wait_until_loading_indicator_invisible

  or

    element_with_vcr \
      :link_with_one_request_and_delay,
      '#link_with_one_request_and_delay',
      fixtures: ['octocat']
      waiter:   { self.wait_until_loading_indicator_invisible and self.wait_for_products }

4. Create possibility to redefine waiter when a click action is done:

    self.confirm_btn.click_and_apply_vcr do
      waiter { self.wait_for_sidebar }
    end

5. Create possibility to define fixtures without the click action:

    self.confirm_btn.vcr do
      path 'products', ['tomato', 'fruit/apple']
      path 'goods', 'cars'

      replace
    end

  and then

    self.confirm_btn.click_and_apply_vcr

  will use previusly defined fixtures

6. The default fixtures should not be rewritten.
7. There should be possibility to change default fixtures:

    self.confirm_btn.vcr do
      path 'products', ['tomato', 'fruit/apple']
      path 'goods', 'cars'

      force_replace
    end