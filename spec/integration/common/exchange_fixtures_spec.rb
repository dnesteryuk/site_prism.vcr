require 'spec_integration_helper'

feature 'Common use cases > Exchange fixture' do
  let(:cat_owner)     { test_app_page.cat_owner }
  let(:test_app_page) { HomePage.new }

  let(:applier_with_event) do
    applier.shift_event {
      test_app_page.link_with_one_request.click
    }
  end

  before do
    test_app_page.load
  end

  context 'without a home path' do
    let(:applier) do
      SPV::Applier.new(test_app_page) do
        fixtures ['ned_stark']
        waiter   &:wait_for_cat_owner
      end
    end

    before do
      applier_with_event.apply_vcr do
        exchange 'ned_stark', 'arya_stark'
      end
    end

    it 'uses the exchanged fixture' do
      expect(cat_owner).to have_content('Arya Stark')
    end
  end

  context 'with a defined home path' do
    let(:applier) do
      SPV::Applier.new(test_app_page) do
        home_path 'custom'

        fixtures ['~/daenerys_targaryen']
        waiter   &:wait_for_cat_owner
      end
    end

    context 'when fixtures are defined without Vcr options' do
      before do
        applier_with_event.apply_vcr do
          exchange '~/daenerys_targaryen', '~/bran_stark'
        end
      end

      it 'uses the exchanged fixture which are stored in the sub directory' do
        expect(cat_owner).to have_content('Bran Stark')
      end
    end

    context 'when fixtures are defined with Vcr options' do
      before do
        applier_with_event.apply_vcr do
          exchange \
            '~/daenerys_targaryen',
            {
              fixture: '~/blank',
              options: {
                erb: {
                  cat_owner: 'Robert Baratheon',
                  port:       Capybara.server_port
                }
              }
            }
        end
      end

      it 'uses the exchanged fixture with specified erb variables' do
        expect(cat_owner).to have_content('Robert Baratheon')
      end
    end
  end
end