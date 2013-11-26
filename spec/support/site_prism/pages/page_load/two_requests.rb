require_relative '../base'

module PageLoad
  class TwoRequestsPage < BasePage
    set_url '/immediate-http-interactions/two-requests'

    vcr_options_for_load do
      fixtures ['ned_stark', 'robb_stark']
      waiter   &:wait_for_ned_stark_and_robb_stark
    end
  end
end