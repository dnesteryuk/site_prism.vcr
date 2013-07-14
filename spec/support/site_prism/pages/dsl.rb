require_relative './base'

class DslPage < BasePage
  set_url '/'

  element :link_to_go_to_another_page, '#link_to_go_to_another_page'

  element_with_vcr \
    :link_with_one_request,
    '#link_with_one_request' do
      fixtures ['ned_stark']
      waiter   &:wait_for_cat_owner
    end

  element_with_vcr \
    :link_with_home_path,
    '#link_with_one_request' do
      home_path 'custom'

      fixtures ['~/daenerys_targaryen']
      waiter   &:wait_for_cat_owner
    end

  element_with_vcr \
    :link_with_one_request_and_delay,
    '#link_with_one_request_and_delay' do
      fixtures ['ned_stark']
      waiter   &:wait_for_cat_owner
    end

  element_with_vcr \
    :link_with_2_requests,
    '#link_with_2_requests' do
      fixtures ['ned_stark', 'robb_stark']
      waiter   &:wait_for_ned_stark_and_robb_stark
    end

  element_with_vcr \
    :link_without_ejecting_fixtures,
    '#link_with_2_requests' do
      fixtures ['ned_stark', 'robb_stark']
      waiter({eject_cassettes: false}, &:wait_for_ned_stark_and_robb_stark)
    end
end