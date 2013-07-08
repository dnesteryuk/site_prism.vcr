require_relative '../base'

module ImmediateHttpInteractions
  class OptionsInHashPage < BasePage
    set_url '/immediate-http-interactions/one-request'

    vcr_options_for_load \
      fixtures: ['ned_stark'],
      waiter:   :wait_for_cat_owner
  end
end