require_relative '../base'

module PageLoad
  class OneRequestPage < BasePage
    set_url '/immediate-http-interactions/one-request?cat={cat}'
    set_url_matcher /immediate\-http\-interactions\/one\-request/

    vcr_options_for_load do
      fixtures ['ned_stark']
      waiter   &:wait_for_cat_owner
    end
  end
end