require_relative './base'

class AdvancedDslPage < BasePage
  set_url '/'

  element_with_vcr \
    :link_with_one_request,
    '#link_with_one_request' do
      fixtures ['octocat']
      waiter   :wait_for_result_block
    end

  element_with_vcr \
    :link_with_home_path,
    '#link_with_one_request' do
      home_path 'custom'

      fixtures ['~/octocus']
      waiter   :wait_for_result_block
    end
end