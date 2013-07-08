require_relative '../base'

module ImmediateHttpInteractions
  class HomePathPage < BasePage
    set_url '/immediate-http-interactions/one-request'

    vcr_options_for_load do
      home_path 'custom'

      fixtures ['~/daenerys_targaryen']
      waiter   :wait_for_cat_owner
    end
  end
end