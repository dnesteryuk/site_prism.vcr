require_relative '../base'

module ImmediateHttpInteractions
  class WaiterWithoutFixturesEjectPage < BasePage
    set_url '/immediate-http-interactions/two-requests'

    vcr_options_for_load do
      fixtures ['ned_stark', 'robb_stark']
      waiter({eject_cassettes: false}, &:wait_for_ned_stark_and_robb_stark)
    end
  end
end