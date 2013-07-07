require_relative '../base'

module ImmediateHttpInteractions
  class HomePathPage < BasePage
    set_url '/immediate-http-interactions/one-request'

    vcr_options_for_load do
      home_path 'custom'

      fixtures ['~/moris']
      waiter   :wait_for_result_block
    end
  end
end