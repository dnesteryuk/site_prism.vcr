require 'spec_integration_helper'

feature 'Advanced DSL' do
  shared_examples 'expecting the custom fixtures on the page' do
    it 'applies a custom fixture considering the defined home path' do
      @test_app_page.result_block.should have_content('Totoro')
    end
  end

  before do
    @test_app_page = AdvancedDslPage.new
    @test_app_page.load
  end

  after do
    eject_fixtures
  end

  it_behaves_like 'clicks and handles one AJAX request'

  context 'when a custom cassette is applied' do
    let(:link) { @test_app_page.link_with_one_request }

    before do
      link.click_and_apply_vcr do
        path 'custom', ['octocus']
      end
    end

    it 'should use a custom cassette instead of a default one for this element' do
      @test_app_page.result_block.should have_content('Octocus')
    end
  end

  context 'when a waiter should be redefined' do
    let(:link) { @test_app_page.link_without_waiter }

    before do
      link.click_and_apply_vcr do
        waiter :wait_for_octocat
      end
    end

    it 'uses a newly defined waiter' do
      @test_app_page.result_block.should have_content('OctocatMartian')
    end
  end

  context 'when a home path is defined' do
    let(:link) { @test_app_page.link_with_home_path }

    context 'when no custom fixture is applied' do
      it 'applies a fixture considering the defined home path' do
        link.click_and_apply_vcr

        @test_app_page.result_block.should have_content('Octocus')
      end
    end

    context 'when a custom fixture is applied' do
      before do
        link.click_and_apply_vcr do
          fixtures ['~/totoro']
        end
      end

      it_behaves_like 'expecting the custom fixtures on the page'
    end

    context 'when a home path is used while defining fixtures within some path' do
      before do
        link.click_and_apply_vcr do
          path '~/', ['totoro']
        end
      end

      it_behaves_like 'expecting the custom fixtures on the page'
    end
  end
end