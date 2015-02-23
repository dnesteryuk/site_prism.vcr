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

    it_behaves_like 'when cassettes are not ejected',
      ['Arya Stark', 'Jon Snow'],
      ['jon_snow', 'arya_stark']
  end
end

shared_examples 'when a default waiter does not eject fixtures' do
  before do
    actor.public_send(action_method)
  end

  it_behaves_like 'when cassettes are not ejected',
    ['Ned Stark', 'Robb Stark'],
    ['robb_stark', 'ned_stark']
end

shared_examples 'when options are redefined for waiters' do
  context 'when the option to not eject default fixtures is passed' do
    before do
      actor.public_send(action_method) do
        waiter_options(eject_cassettes: false)
      end
    end

    it_behaves_like 'when cassettes are not ejected',
      ['Ned Stark', 'Robb Stark'],
      ['robb_stark', 'ned_stark']
  end
end

shared_examples 'when cassettes are ejected by the waiter' do
  let(:path_to_fixture) {
    VCR.configuration.cassette_library_dir + '/newly_recorded.yml'
  }

  before do
    actor.public_send(action_method) do
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