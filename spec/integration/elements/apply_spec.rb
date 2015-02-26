require 'spec_integration_helper'

feature 'Elements > Apply Vcr' do
  # It may be any other event, we use click event
  # because it is the simplest one
  def shift_click_event(link)
    link.shift_event { link.click }
  end

  def shift_click_event_to(link_name)
    link = test_app_page.public_send(link_name)
    shift_click_event(link)
  end

  let(:cat_owner)     { test_app_page.cat_owner }
  let(:test_app_page) { HomePage.new }
  let(:action_method) { :apply_vcr }

  before do
    test_app_page.load
  end

  context 'when VCR is associated with already defined elements' do
    before do
      shift_click_event_to(:link_without_vcr).apply_vcr
    end

    it 'applies a default fixture' do
      expect(test_app_page.cat_owner).to have_content('Ned Stark')
    end
  end

  context 'when there is a delay between clicking and doing an HTTP request' do
    before do
      shift_click_event_to(:link_with_one_request_and_delay).apply_vcr
    end

    it 'applies a fixture and waits for results' do
      expect(cat_owner).to have_content('Ned Stark')
    end
  end

  # TODO: should we write the same test for the page load?
  context 'when an user clicks on the link which causes 2 HTTP requests' do
    before do
      shift_click_event_to(:link_with_2_requests).apply_vcr
    end

    it 'applies 2 fixtures' do
      expect(cat_owner).to have_content('Ned Stark')
      expect(cat_owner).to have_content('Robb Stark')
    end
  end

  context 'waiters' do
    it_behaves_like 'when cassettes are ejected by the waiter' do
      let(:actor) { shift_click_event_to(:link_with_one_request) }
    end

    it_behaves_like 'when a default waiter does not eject fixtures' do
      let(:actor) { shift_click_event_to(:link_without_ejecting_fixtures) }
    end

    it_behaves_like 'when options are redefined for waiters' do
      let(:actor) { shift_click_event_to(:link_with_2_requests) }
    end

    it_behaves_like 'custom waiters' do
      let(:actor) { shift_click_event_to(:link_with_2_requests) }
    end
  end

  it_behaves_like 'when a shorcut path is define' do
    let(:actor) { shift_click_event_to(:link_with_one_request) }
  end
end
