shared_examples 'when a custom fixture is applied' do
  context 'when no VCR options are passed' do
    before do
      actor.public_send(action_method) do
        path 'custom', ['daenerys_targaryen']
      end
    end

    it 'uses a custom fixture instead of a default one' do
      expect(cat_owner).to have_content('Daenerys Targaryen')
    end
  end

  context 'when VCR options are passed' do
    before do
      actor.public_send(action_method) do
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
      actor.public_send(action_method) do
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
end