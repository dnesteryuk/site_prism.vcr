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
              erb: {cat_owner: 'Robert Baratheon'}
            }
          }
        ]
      end
    end

    it 'uses a custom fixture instead of a default one and takes VCR options' do
      expect(cat_owner).to have_content('Robert Baratheon')
    end
  end
end