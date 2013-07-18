shared_examples 'custom waiters' do
  context 'when a waiter is redefined' do
    before do
      actor.public_send(action_method) do
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
      actor.public_send(action_method)

      expect(cat_owner).to have_content('Ned Stark')
      expect(cat_owner).to have_content('Robb Stark')
    end
  end

  context 'when a custom waiter does not eject fixtures' do
    before do
      my_page = test_app_page

      actor.public_send(action_method) do
        fixtures ['arya_stark', 'jon_snow']

        waiter({eject_cassettes: false}, &:wait_for_arya_stark_and_jon_snow)
      end
    end

    after do
      SPV::Helpers.eject_all_cassettes
    end

    it 'uses a custom waiter' do
      expect(cat_owner).to have_content('Arya Stark')
      expect(cat_owner).to have_content('Jon Snow')
    end

    it 'VCR contains all cassettes' do
      expect(VCR.eject_cassette.name).to eq('jon_snow')
      expect(VCR.eject_cassette.name).to eq('arya_stark')
      expect(VCR.eject_cassette).to be_nil
    end
  end
end

shared_examples 'when a default waiter does not eject fixtures' do
  before do
    actor.public_send(action_method)
  end

  after do
    SPV::Helpers.eject_all_cassettes
  end

  it 'uses a default waiter' do
    expect(cat_owner).to have_content('Ned Stark')
    expect(cat_owner).to have_content('Robb Stark')
  end

  it 'VCR contains all cassettes' do
    expect(VCR.eject_cassette.name).to eq('robb_stark')
    expect(VCR.eject_cassette.name).to eq('ned_stark')
    expect(VCR.eject_cassette).to be_nil
  end
end