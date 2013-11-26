require_relative './one_request'

module PageLoad
  class SubPage < OneRequestPage
    set_url '/immediate-http-interactions/one-request'
  end
end