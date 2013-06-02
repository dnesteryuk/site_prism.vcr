require 'spec_integration_helper'

feature 'Immediate http interactions > Advanced DSL' do
  let(:result_block)  { test_app_page.result_block }
  let(:test_app_page) { ImmediateHttpInteractions::OneRequestPage.new }
  let(:action_method) { :load_and_apply_vcr }

  it 'opens the page and applies default fixtures' do
    test_app_page.load_and_apply_vcr

    result_block.should have_content('Octocat')
  end

  it_behaves_like 'when a custom cassette is applied' do
    let(:actor) { test_app_page }
  end

  context 'waiters' do
    it_behaves_like 'custom waiters' do
      let(:actor)         { ImmediateHttpInteractions::TwoRequestsPage.new }
      let(:test_app_page) { actor }
    end

    it_behaves_like 'when a default waiter is defined within a block' do
      let(:actor) { ImmediateHttpInteractions::WaiterInBlockPage.new }
    end
  end

  it_behaves_like 'when a home path is define' do
    let(:actor_with_home_path)    { ImmediateHttpInteractions::HomePathPage.new }
    let(:actor_without_home_path) { ImmediateHttpInteractions::OneRequestPage.new }
  end

  it_behaves_like 'when a default fixture is exchanged' do
    let(:actor_without_home_path) { ImmediateHttpInteractions::TwoRequestsPage.new }
    let(:actor_with_home_path)    { ImmediateHttpInteractions::HomePathPage.new }
  end
end