require_relative '../base'

module ImmediateHttpInteractions
  class OneRequestPage < BasePage
    set_url '/immediate-http-interactions/one-request?car={car}'
    set_url_matcher /immediate\-http\-interactions\/one\-request/

    vcr_options_for_load do
      fixtures ['ned_stark']
      waiter   :wait_for_cat_owner
    end
  end
end