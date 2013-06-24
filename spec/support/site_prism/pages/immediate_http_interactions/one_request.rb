require_relative '../base'

module ImmediateHttpInteractions
  class OneRequestPage < BasePage
    set_url '/immediate-http-interactions/one-request?car={car}'

    vcr_options_for_load do
      fixtures ['octocat']
      waiter   :wait_for_result_block
    end
  end
end