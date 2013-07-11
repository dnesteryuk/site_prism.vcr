require 'spec_integration_helper'

feature 'Page Load' do
  let(:one_request_page) { ImmediateHttpInteractions::OneRequestPage.new }

  before do
    page = SimpleDslPage.new
    page.load

    one_request_page.apply_vcr proc { page.link_to_go_to_another_page.click }
  end

  it 'loads fixtures on opening a page by click' do
    one_request_page.displayed?.should be_true

    one_request_page.should have_content('Ned Stark')
  end
end