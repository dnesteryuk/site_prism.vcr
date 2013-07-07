require_relative './base'

class SimpleDslPage < BasePage
  set_url '/'

  element_with_vcr \
    :link_with_one_request,
    '#link_with_one_request',
    fixtures: ['max'],
    waiter:   :wait_for_result_block

  element_with_vcr \
    :link_with_one_request_and_delay,
    '#link_with_one_request_and_delay',
    fixtures: ['max'],
    waiter:   :wait_for_result_block

  element_with_vcr \
    :link_with_2_requests,
    '#link_with_2_requests',
    fixtures: ['max', 'felix'],
    waiter:   :wait_for_max_and_felix
end