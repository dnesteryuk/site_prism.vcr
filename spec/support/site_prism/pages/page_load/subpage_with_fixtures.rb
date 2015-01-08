require_relative './one_request'

module PageLoad
  class SubPageWithFixtures < OneRequestPage
    set_url '/immediate-http-interactions/two-requests'

    adjust_parent_vcr_options do
      fixtures ['robb_stark']
      waiter   &:wait_for_ned_stark_and_robb_stark

      union
    end
  end
end