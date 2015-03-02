require 'spec_integration_helper'

feature 'Common use cases > Home Path' do
  shared_examples 'expects the custom fixture on the page' do
    it 'applies a stored fixture in the directory defined in the home path' do
      expect(cat_owner).to have_content('Bran Stark')
    end
  end

  let(:cat_owner)     { test_app_page.cat_owner }
  let(:test_app_page) { HomePage.new }

  let(:applier) do
    SPV::Applier.new(test_app_page) do
      home_path 'custom'

      fixtures ['~/daenerys_targaryen']
      waiter   &:wait_for_cat_owner
    end
  end

  let(:applier_with_event) do
    applier.shift_event {
      test_app_page.link_with_one_request.click
    }
  end

  before do
    test_app_page.load
  end

  context 'when no custom fixture is applied' do
    it 'applies a stored fixture in the directory defined as a home path' do
      applier_with_event.apply_vcr

      expect(cat_owner).to have_content('Daenerys Targaryen')
    end
  end

  context 'when a custom fixture is applied' do
    before do
      applier_with_event.apply_vcr do
        fixtures ['~/bran_stark']
      end
    end

    it_behaves_like 'expects the custom fixture on the page'
  end

  context 'when a home path is used within the path helper method' do
    before do
      applier_with_event.apply_vcr do
        path '~/', ['bran_stark']
      end
    end

    it_behaves_like 'expects the custom fixture on the page'
  end

  context 'when a home path is directly defined in the block for applying fixtures' do
    let(:applier) do
      SPV::Applier.new(test_app_page) do
        fixtures ['custom/daenerys_targaryen']
        waiter   &:wait_for_cat_owner
      end
    end

    before do
      applier_with_event.apply_vcr do
        home_path 'custom'

        fixtures ['~/bran_stark']
      end
    end

    it_behaves_like 'expects the custom fixture on the page'
  end

  context 'when a custom fixture which is stored in the parent directory of the home path is applied' do
    before do
      applier_with_event.apply_vcr do
        fixtures ['~/../arya_stark']
      end
    end

    it 'applies a stored fixture in the parent directory of the home path' do
      expect(cat_owner).to have_content('Arya Stark')
    end
  end

  context 'when a home path is used to point to a cassette in a sub directory' do
    before do
      applier_with_event.apply_vcr do
        path '~/', ['subpath/sansa_stark']
      end
    end

    it 'applies a stored fixture in the sub directory of the home path' do
      expect(cat_owner).to have_content('Sansa Stark')
    end
  end
end