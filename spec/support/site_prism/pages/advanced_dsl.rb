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

  # TODO: Write patch for SitePrism to raise an error if an being waited element
  # is not on a page.
  def wait_for_octocat_and_martian
    if !console_block.wait_for_octocat && !console_block.wait_for_martian
      raise 'The page does not have expected elements on the page'
    end
  end

  def wait_for_tom_and_zeus
    if !console_block.wait_for_tom && !console_block.wait_for_zeus
      raise 'The page does not have expected elements on the page'
    end
  end
end