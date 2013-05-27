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

  element_with_vcr \
    :link_with_2_requests,
    '#link_with_2_requests',
    fixtures: ['tom', 'zeus'],
    waiter:   :wait_for_tom_and_zeus

  element_with_vcr \
    :link_tom_and_zeus_with_block_waiter,
    '#link_with_2_requests',
    fixtures: ['tom', 'zeus'],
    waiter:   proc{ self.wait_for_tom_and_zeus }

  def wait_for_octocat_and_zeus
    console_block.octocat && console_block.zeus
  end
end