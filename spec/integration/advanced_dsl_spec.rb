require 'spec_integration_helper'

feature 'Advanced DSL' do
  before do
    @test_app_page = TestAppPage.new
    @test_app_page.load
  end

  after do
    eject_fixtures
  end

  context 'when a custom cassette is applied' do
    let(:link) { @test_app_page.link_with_one_request }

    before do
      link.click_and_apply_vcr do
        path 'custom', ['octocus']

        replace
      end
    end

    it 'should use a custom cassette instead of a default one for this element' do
      @test_app_page.result_block.should have_content('Octocus')
    end
  end
end