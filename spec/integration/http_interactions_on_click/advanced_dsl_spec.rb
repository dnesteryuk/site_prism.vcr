require 'spec_integration_helper'

feature 'Http interactions on click > Advanced DSL' do
  let(:result_block)  { test_app_page.result_block }
  let(:test_app_page) { AdvancedDslPage.new }
  let(:action_method) { :click_and_apply_vcr }

  before do
    test_app_page.load
  end

  it_behaves_like 'clicks and handles one AJAX request'

  it_behaves_like 'when a custom cassette is applied' do
    let(:actor) { test_app_page.link_with_one_request }
  end

  context 'waiters' do
    it_behaves_like 'custom waiters' do
      let(:actor) { test_app_page.link_with_2_requests }
    end

    it_behaves_like 'when a default waiter is defined within a block' do
      let(:actor) { test_app_page.link_tom_and_zeus_with_block_waiter }
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