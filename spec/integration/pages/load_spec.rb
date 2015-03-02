require 'spec_integration_helper'

feature 'Pages > Load' do
  let(:cat_owner)     { test_app_page.cat_owner }
  let(:test_app_page) { PageLoad::OneRequestPage.new }
  let(:action_method) { :load_and_apply_vcr }

  it 'applies additional query to url' do
    test_app_page.load_and_apply_vcr(cat: 'ford')

    expect(page.current_url).to match(/\?cat=ford/)
  end

  context 'when a subpage inherits a page with a defined vcr options' do
    let(:test_app_page) { PageLoad::SubPage.new }

    it 'subpage inherits the defined options for its parent page' do
      test_app_page.load_and_apply_vcr

      expect(cat_owner).to have_content('Ned Stark')
    end

    context 'when a subpage defines own fixtures' do
      let(:test_app_page) { PageLoad::SubPageWithFixtures.new }

      it 'subpage uses fixtures from the parent page and own fixtures' do
        test_app_page.load_and_apply_vcr

        expect(cat_owner).to have_content('Ned Stark')
        expect(cat_owner).to have_content('Robb Stark')
      end
    end
  end
end