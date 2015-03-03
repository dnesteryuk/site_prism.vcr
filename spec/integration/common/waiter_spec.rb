require 'spec_integration_helper'

feature 'Common use cases > Waiter' do
  shared_examples 'when cassettes are not ejected' do |texts, cassettes|
    after do
      SPV::Helpers.eject_all_cassettes
    end

    it 'uses a default waiter' do
      texts.each do |expected_text|
        expect(cat_owner).to have_content(expected_text)
      end
    end

    it 'VCR contains all cassettes' do
      cassettes.each do |expected_cassette|
        expect(VCR.eject_cassette.name).to eq(expected_cassette)
      end

      expect(VCR.eject_cassette).to be_nil
    end
  end

  let(:cat_owner)     { test_app_page.cat_owner }
  let(:test_app_page) { HomePage.new }

  let(:applier) do
    SPV::Applier.new(test_app_page) do
      fixtures ['ned_stark', 'robb_stark']
      waiter   &:wait_for_ned_stark_and_robb_stark
    end
  end

  let(:applier_with_event) do
    applier.shift_event {
      test_app_page.link_with_2_requests.click
    }
  end

  before do
    test_app_page.load
  end

  context 'custom waiters' do
    context 'when a waiter is redefined' do
      before do
        applier_with_event.apply_vcr do
          fixtures ['arya_stark', 'jon_snow']

          waiter &:wait_for_arya_stark_and_jon_snow
        end
      end

      it 'uses a custom waiter' do
        expect(cat_owner).to have_content('Arya Stark')
        expect(cat_owner).to have_content('Jon Snow')
      end

      it 'VCR has not any fixtures' do
        expect(VCR.eject_cassette).to be_nil
      end

      it 'uses a default waiter after using the custom waiter' do
        applier_with_event.apply_vcr

        expect(cat_owner).to have_content('Ned Stark')
        expect(cat_owner).to have_content('Robb Stark')
      end
    end

    context 'when a custom waiter does not eject fixtures' do
      before do
        applier_with_event.apply_vcr do
          fixtures ['arya_stark', 'jon_snow']

          waiter({eject_cassettes: false}, &:wait_for_arya_stark_and_jon_snow)
        end
      end

      it_behaves_like 'when cassettes are not ejected',
        ['Arya Stark', 'Jon Snow'],
        ['jon_snow', 'arya_stark']
    end
  end

  context 'when a default waiter does not eject fixtures' do
    let(:applier) do
      SPV::Applier.new(test_app_page) do
        fixtures ['ned_stark', 'robb_stark']

        waiter({eject_cassettes: false}, &:wait_for_ned_stark_and_robb_stark)
      end
    end

    before do
      applier_with_event.apply_vcr
    end

    it_behaves_like 'when cassettes are not ejected',
      ['Ned Stark', 'Robb Stark'],
      ['robb_stark', 'ned_stark']
  end

  context 'when the option to not eject default fixtures is passed' do
    before do
      applier_with_event.apply_vcr do
        waiter_options(eject_cassettes: false)
      end
    end

    it_behaves_like 'when cassettes are not ejected',
      ['Ned Stark', 'Robb Stark'],
      ['robb_stark', 'ned_stark']
  end

  context 'when one specific cassette should not be ejected' do
    before do
      applier_with_event.apply_vcr do
        fixtures [
          'ned_stark',
          {fixture: 'robb_stark', options: {eject: false}}
        ]
      end
    end

    after do
      SPV::Helpers.eject_all_cassettes
    end

    it 'VCR contains one cassette' do
      expect(VCR.eject_cassette.name).to eq('robb_stark')
    end
  end

  context 'when cassettes are ejected by the waiter' do
    let(:path_to_fixture) {
      VCR.configuration.cassette_library_dir + '/newly_recorded.yml'
    }

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
      applier_with_event.apply_vcr do
        fixtures ['newly_recorded']

        replace
      end
    end

    after do
      File.unlink(path_to_fixture) if File.exists?(path_to_fixture)
    end

    it 'stores a new cassette' do
      expect(File.exists?(path_to_fixture)).to be_truthy
    end
  end
end