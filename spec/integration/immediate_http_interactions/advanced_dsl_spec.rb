require 'spec_integration_helper'

feature 'Immediate http interactions > Advanced DSL' do
  let(:result_block)  { test_app_page.result_block }

  let(:test_app_page) { ImmediateHttpInteractions::OneRequestPage.new }

  it 'opens the page and applies default fixtures' do
    test_app_page.load_and_apply_vcr

    result_block.should have_content('Octocat')
  end

  context 'when a custom cassette is applied' do
    before do
      test_app_page.load_and_apply_vcr do
        path 'custom', ['octocus']
      end
    end

    it 'uses a custom cassette instead of a default one' do
      result_block.should have_content('Octocus')
    end
  end

  context 'custom waiters' do
    let(:test_app_page) { ImmediateHttpInteractions::TwoRequestsPage.new }

    before do
      test_app_page.load_and_apply_vcr do
        fixtures ['octocat', 'martian']

        waiter :wait_for_octocat_and_martian
      end
    end

    it 'uses a custom waiter' do
      result_block.should have_content('Octocat')
      result_block.should have_content('Martian')
    end
  end

  context 'when a home path is defined' do
    let(:test_app_page) { ImmediateHttpInteractions::HomePathPage.new }

    context 'when no custom fixture is applied' do
      before do
        test_app_page.load_and_apply_vcr
      end

      it 'applies a fixture considering the defined home path' do
        result_block.should have_content('Octocus')
      end
    end

    context 'when a custom fixture is applied' do
      before do
        test_app_page.load_and_apply_vcr do
          path '~/', ['totoro']
        end
      end

      it_behaves_like 'expecting the custom fixtures on the page'
    end
  end

  context 'when a default fixture is exchanged' do
    it 'uses the exchanged fixture'
  end
end