require_relative './base'

class SimpleDslPage < BasePage
  set_url '/'

  element_with_vcr \
    :link_with_one_request,
    '#link_with_one_request',
    fixtures: ['octocat'],
    waiter:   :wait_for_result_block

  element_with_vcr \
    :link_with_one_request_and_delay,
    '#link_with_one_request_and_delay',
    fixtures: ['octocat'],
    waiter:   :wait_for_result_block

  element_with_vcr \
    :link_with_2_requests,
    '#link_with_2_requests',
    fixtures: ['octocat', 'martian'],
    waiter:   :wait_for_octocat_and_martian
end