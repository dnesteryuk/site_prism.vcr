require_relative '../base'

module ImmediateHttpInteractions
  class OptionsInHashPage < BasePage
    set_url '/immediate-http-interactions/one-request'

    vcr_options_for_load \
      fixtures: ['octocat'],
      waiter:   :wait_for_result_block
  end
end