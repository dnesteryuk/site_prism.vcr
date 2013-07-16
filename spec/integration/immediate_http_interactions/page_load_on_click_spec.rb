require 'spec_integration_helper'

feature 'Immediate Http interactions > Page load on click' do
  let(:one_request_page) { ImmediateHttpInteractions::OneRequestPage.new }

  before do
    index_page = HomePage.new
    index_page.load

    one_request_page.apply_vcr proc { index_page.link_to_go_to_another_page.click }
  end

  it 'loads fixtures on opening a page by click on a link' do
    expect(one_request_page.displayed?).to be_true

    expect(one_request_page).to have_content('Ned Stark')
  end
end