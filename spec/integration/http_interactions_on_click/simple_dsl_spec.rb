require 'spec_integration_helper'

feature 'Http interactions on click > Simple DSL' do
  let(:test_app_page) { SimpleDslPage.new }
  let(:result_block)  { test_app_page.result_block }

  before do
    test_app_page.load
  end

  it_behaves_like 'clicks and handles one AJAX request'

  context 'when a custom cassette is applied' do
    let(:link) { test_app_page.link_with_one_request }

    before do
      link.click_and_apply_vcr do
        fixtures ['custom/moris']
      end
    end

    it 'uses a custom cassette instead of a default one for this element' do
      result_block.should have_content('Moris')
    end

    context 'when a click is used again without specifying a custom fixture' do
      it 'uses a default fixture again' do
        link.click_and_apply_vcr

        result_block.should have_content('Max')
      end
    end
  end

  context 'when there is a delay between clicking and doing an AJAX request' do
    before do
      test_app_page.link_with_one_request_and_delay.click_and_apply_vcr
    end

    it 'applies a fixture' do
      result_block.should have_content('Max')
    end
  end

  context 'when an user clicks on the link which do 2 AJAX requests' do
    before do
      test_app_page.link_with_2_requests.click_and_apply_vcr
    end

    it 'applies 2 fixtures' do
      result_block.should have_content('Max')
      result_block.should have_content('Felix')
    end
  end
end