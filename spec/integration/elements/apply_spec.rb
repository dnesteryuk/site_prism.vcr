require 'spec_integration_helper'

feature 'Elements > Apply Vcr' do
  # It may be any other event, we use this one
  # because it is the simplest one
  def shift_click_event(link, &adjuster)
    link.shift_event { link.click }
  end

  let(:cat_owner)     { test_app_page.cat_owner }
  let(:test_app_page) { HomePage.new }
  let(:action_method) { :apply_vcr }

  before do
    test_app_page.load
  end

  context 'clicks and handles one HTTP request' do
    before do
      shift_click_event(test_app_page.link_with_one_request).apply_vcr
    end

    it 'applies a default fixture' do
      expect(test_app_page.cat_owner).to have_content('Ned Stark')
    end
  end

  context 'when Vcr is associated for already defined elements' do
    before do
      shift_click_event(test_app_page.link_without_vcr).apply_vcr
    end

    it 'applies a default fixture' do
      expect(test_app_page.cat_owner).to have_content('Ned Stark')
    end
  end

  context 'when there is a delay between clicking and doing an HTTP request' do
    before do
      shift_click_event(test_app_page.link_with_one_request_and_delay).apply_vcr
    end

    it 'applies a fixture and the test waits for results' do
      expect(cat_owner).to have_content('Ned Stark')
    end
  end

  # TODO: should we write the same test for the page load?
  context 'when an user clicks on the link which causes 2 HTTP requests' do
    before do
      shift_click_event(test_app_page.link_with_2_requests).apply_vcr
    end

    it 'applies 2 fixtures' do
      expect(cat_owner).to have_content('Ned Stark')
      expect(cat_owner).to have_content('Robb Stark')
    end
  end

  it_behaves_like 'when a custom fixture is applied' do
    let(:actor) { shift_click_event(test_app_page.link_with_one_request) }

    context 'when clicks again without specifying a custom fixture' do
      it 'uses a default fixture again' do
        actor.apply_vcr

        expect(cat_owner).to have_content('Ned Stark')
      end
    end
  end

  context 'waiters' do
    it_behaves_like 'when a default waiter does not eject fixtures' do
      let(:actor) { shift_click_event(test_app_page.link_without_ejecting_fixtures) }
    end

    it_behaves_like 'custom waiters' do
      let(:actor) { shift_click_event(test_app_page.link_with_2_requests) }
    end
  end

  it_behaves_like 'when a home path is define' do
    let(:actor_with_home_path)    { shift_click_event(test_app_page.link_with_home_path) }
    let(:actor_without_home_path) { shift_click_event(test_app_page.link_with_one_request) }
  end

  it_behaves_like 'when a default fixture is exchanged' do
    let(:actor_with_home_path)    { shift_click_event(test_app_page.link_with_home_path) }
    let(:actor_without_home_path) { shift_click_event(test_app_page.link_with_2_requests) }
  end
end
