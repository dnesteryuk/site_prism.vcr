class TestAppPage < SitePrism::Page
  set_url '/'

  element :result_block, '#result'

  element_with_vcr \
    :link_with_one_request,
    '#link_with_one_request',
    fixtures: ['octocat']

  element_with_vcr \
    :link_with_one_request_and_delay,
    '#link_with_one_request_and_delay',
    fixtures: ['octocat']

  element_with_vcr \
    :link_with_2_requests,
    '#link_with_2_requests',
    fixtures: ['octocat', 'martian']
end