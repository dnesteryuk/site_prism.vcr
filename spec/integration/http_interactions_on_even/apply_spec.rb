require 'spec_integration_helper'

feature 'Http interactions on event provided as a proc' do
  let(:cat_owner)     { test_app_page.cat_owner }
  let(:test_app_page) { HomePage.new }

  before do
    test_app_page.load
  end

  context 'applies and handles HTTP request' do
    before do
      test_app_page.link_with_one_request.apply_vcr(
        -> {test_app_page.link_with_one_request.click}
      )
    end

    it 'applies a default fixture' do
      expect(test_app_page.cat_owner).to have_content('Ned Stark')
    end
  end
end
