require 'spec_integration_helper'

feature 'Http interactions on click > Advanced DSL' do
  let(:cat_owner)     { test_app_page.cat_owner }
  let(:test_app_page) { AdvancedDslPage.new }
  let(:action_method) { :click_and_apply_vcr }

  before do
    test_app_page.load
  end

  it_behaves_like 'clicks and handles one AJAX request'

  it_behaves_like 'when a custom cassette is applied' do
    let(:actor) { test_app_page.link_with_one_request }

    context 'when a click is used again without specifying a custom fixture' do
      it 'uses a default fixture again' do
        actor.click_and_apply_vcr

        expect(cat_owner).to have_content('Ned Stark')
      end
    end
  end

  context 'when there is a delay between clicking and doing an AJAX request' do
    before do
      test_app_page.link_with_one_request_and_delay.click_and_apply_vcr
    end

    it 'applies a fixture' do
      expect(cat_owner).to have_content('Ned Stark')
    end
  end

  context 'when an user clicks on the link which do 2 AJAX requests' do
    before do
      test_app_page.link_with_2_requests.click_and_apply_vcr
    end

    it 'applies 2 fixtures' do
      expect(cat_owner).to have_content('Ned Stark')
      expect(cat_owner).to have_content('Robb Stark')
    end
  end

  context 'waiters' do
    it_behaves_like 'custom waiters' do
      let(:actor) { test_app_page.link_with_2_requests }
    end

    it_behaves_like 'when a default waiter is defined within a block' do
      let(:actor) { test_app_page.link_robb_stark_and_ned_stark_with_block_waiter }
    end
  end

  it_behaves_like 'when a home path is define' do
    let(:actor_with_home_path)    { test_app_page.link_with_home_path }
    let(:actor_without_home_path) { test_app_page.link_with_one_request }
  end

  it_behaves_like 'when a default fixture is exchanged' do
    let(:actor_without_home_path) { test_app_page.link_with_2_requests }
    let(:actor_with_home_path)    { test_app_page.link_with_home_path }
  end
end