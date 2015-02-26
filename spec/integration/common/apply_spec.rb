require 'spec_integration_helper'

feature 'Common use cases' do
  let(:cat_owner)     { test_app_page.cat_owner }
  let(:test_app_page) { HomePage.new }

  let(:applier) do
    SPV::Applier.new(test_app_page) do
      fixtures ['ned_stark']
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

  context 'do action and handles one HTTP request' do
    it 'applies a default fixture' do
      applier_with_event.apply_vcr

      expect(cat_owner).to have_content('Ned Stark')
    end
  end

  context 'when a custom fixture is applied' do
    context 'when no VCR options are passed' do
      before do
        applier_with_event.apply_vcr do
          path 'custom', ['daenerys_targaryen']
        end
      end

      it 'uses a custom fixture instead of a default one' do
        expect(cat_owner).to have_content('Daenerys Targaryen')
      end
    end

    context 'when VCR options are passed' do
      before do
        applier_with_event.apply_vcr do
          path 'custom', [
            {
              fixture: 'blank',
              options: {
                erb: {
                  cat_owner: 'Robert Baratheon',
                  port:       Capybara.server_port
                }
              }
            }
          ]
        end
      end

      it 'uses a custom fixture instead of a default one and takes VCR options' do
        expect(cat_owner).to have_content('Robert Baratheon')
      end
    end

    context 'when "replace" action is defined before defining fixtures to be used for replacing' do
      before do
        applier_with_event.apply_vcr do
          replace
          path 'custom', ['daenerys_targaryen']
        end
      end

      after do
        SPV::Helpers.eject_all_cassettes
      end

      it 'uses a custom fixture anyway' do
        expect(cat_owner).to have_content('Daenerys Targaryen')
      end
    end

    context 'when do the action again without specifying a custom fixture' do
      it 'uses a default fixture again' do
        applier_with_event.apply_vcr

        expect(cat_owner).to have_content('Ned Stark')
      end
    end
  end

  context 'when a default fixture is exchanged' do
    context 'without a home path' do
      before do
        applier_with_event.apply_vcr do
          waiter &:wait_for_cat_owner

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
end