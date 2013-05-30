require 'spec_integration_helper'

feature 'Immediate http interactions > Advanced DSL' do
  let(:result_block)  { test_app_page.result_block }

  context 'one HTTP request' do
    let(:test_app_page) { ImmediateHttpInteractions::OneRequestPage.new }

    it 'opens the page and applies default fixtures' do
      test_app_page.load_and_apply_vcr

      result_block.should have_content('Octocat')
    end

    context 'when custom fixtures are defined' do
      before do
        test_app_page.load_and_apply_vcr do
          path 'custom', ['octocus']
        end
      end

      it 'uses a custom cassette instead of a default one' do
        result_block.should have_content('Octocus')
      end
    end
  end

  context 'when a default fixture is exchanged'
end