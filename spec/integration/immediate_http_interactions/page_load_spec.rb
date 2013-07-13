require 'spec_integration_helper'

feature 'Page Load' do
  let(:one_request_page) { ImmediateHttpInteractions::OneRequestPage.new }

  before do
    page = DslPage.new
    page.load

    one_request_page.apply_vcr proc { page.link_to_go_to_another_page.click }
  end

  it 'loads fixtures on opening a page by click on a link' do
    expect(one_request_page.displayed?).to be_true

    expect(one_request_page).to have_content('Ned Stark')
  end
end