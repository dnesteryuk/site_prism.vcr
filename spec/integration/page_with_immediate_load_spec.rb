require 'spec_integration_helper'

feature 'Page with immediate load' do
  let(:test_app_page) { PageWithLoad.new }

  it 'opens the page and applies default fixtures' do
    test_app_page.load_and_apply_vcr
  end

  context 'when custom fixtures are defined' do
    it 'uses custom fixtures for loading a page'
  end
end