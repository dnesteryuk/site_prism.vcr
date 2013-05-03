class BasePage < SitePrism::Page
  element :result_block,  '#result'
  element :console_block, '#console'

  element_with_vcr \
    :link_without_waiter,
    '#link_with_2_requests',
    fixtures: ['octocat', 'martian']

  def wait_for_octocat
    console_block.has_content?('Octocat')
    console_block.has_content?('Martian')
  end
end