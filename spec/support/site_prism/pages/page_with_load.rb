require_relative './base'

class PageWithLoad < BasePage
  set_url '/page_with_load'

  vcr_options_for_load do
    fixtures ['tom', 'zeus']
    waiter   :wait_for_tom_and_zeus
  end
end