require 'spec_integration_helper'

feature 'Http interactions on click > Advanced DSL' do
  shared_examples 'expecting the custom fixtures on the page' do
    it 'applies a custom fixture considering the defined home path' do
      test_app_page.result_block.should have_content('Totoro')
    end
  end

  let(:result_block)  { test_app_page.result_block }
  let(:test_app_page) { AdvancedDslPage.new }

  before do
    test_app_page.load
  end

  it_behaves_like 'clicks and handles one AJAX request'

  context 'when a custom cassette is applied' do
    let(:link) { test_app_page.link_with_one_request }

    before do
      link.click_and_apply_vcr do
        path 'custom', ['octocus']
      end
    end

    it 'uses a custom cassette instead of a default one for this element' do
      result_block.should have_content('Octocus')
    end
  end

  context 'custom waiters' do
    let(:link) { test_app_page.link_with_2_requests }

    context 'when a waiter is redefined' do
      before do
        link.click_and_apply_vcr do
          fixtures ['octocat', 'martian']

          waiter :wait_for_octocat_and_martian
        end
      end

      it 'uses a newly defined waiter' do
        result_block.should have_content('Octocat')
        result_block.should have_content('Martian')
      end

      it 'uses a default waiter after using the custom waiter' do
        link.click_and_apply_vcr

        result_block.should have_content('Tom')
        result_block.should have_content('Zeus')
      end
    end

    context 'when a block is used to define a custom waiter' do
      before do
        my_page = test_app_page

        link.click_and_apply_vcr do
          fixtures ['octocat', 'martian']

          waiter { my_page.wait_for_octocat_and_martian}
        end
      end

      it 'uses a newly defined waiter' do
        result_block.should have_content('Octocat')
        result_block.should have_content('Martian')
      end
    end
  end

  context 'when a default waiter is defined within a block' do
    let(:link) { test_app_page.link_tom_and_zeus_with_block_waiter }

    before do
      link.click_and_apply_vcr
    end

    it 'uses a default waiter' do
      result_block.should have_content('Tom')
      result_block.should have_content('Zeus')
    end
  end

  context 'when a home path is defined' do
    let(:link) { test_app_page.link_with_home_path }

    context 'when no custom fixture is applied' do
      it 'applies a fixture considering the defined home path' do
        link.click_and_apply_vcr

        result_block.should have_content('Octocus')
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

  context 'when a default fixture is exchanged' do
    let(:link) { test_app_page.link_with_2_requests }

    before do
      link.click_and_apply_vcr do
        waiter :wait_for_octocat_and_zeus

        exchange ['tom'], ['octocat']
      end
    end

    it 'uses the exchanged fixture' do
      result_block.should have_content('Octocat')
      result_block.should have_content('Zeus')
    end

    it 'uses the exchanged fixture which are stored in the sub directory'
  end
end