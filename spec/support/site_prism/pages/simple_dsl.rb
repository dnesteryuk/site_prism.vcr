require_relative './base'

class SimpleDslPage < BasePage
  set_url '/'

  element :link_to_go_to_another_page, '#link_to_go_to_another_page'

  element_with_vcr \
    :link_with_one_request,
    '#link_with_one_request',
    fixtures: ['ned_stark'],
    waiter:   :wait_for_cat_owner

  element_with_vcr \
    :link_with_one_request_and_delay,
    '#link_with_one_request_and_delay',
    fixtures: ['ned_stark'],
    waiter:   :wait_for_cat_owner

  element_with_vcr \
    :link_with_2_requests,
    '#link_with_2_requests',
    fixtures: ['ned_stark', 'robb_stark'],
    waiter:   :wait_for_ned_stark_and_robb_stark
end