shared_examples 'when a home path is define' do
  context 'when no custom fixture is applied' do
    before do
      actor_with_home_path.public_send(action_method)
    end

    it 'applies a fixture considering the defined home path' do
      result_block.should have_content('Moris')
    end
  end

  context 'when a custom fixture is applied' do
    before do
      actor_with_home_path.public_send(action_method) do
        fixtures ['~/totoro']
      end
    end

    it_behaves_like 'expecting the custom fixtures on the page'
  end

  context 'when a home path is used while defining fixtures within some path' do
    before do
      actor_with_home_path.public_send(action_method) do
        path '~/', ['totoro']
      end
    end

    it_behaves_like 'expecting the custom fixtures on the page'
  end

  context 'when a home path is directly defined in the block for applying fixtures' do
    before do
      actor_without_home_path.public_send(action_method) do
        home_path 'custom'

        path '~/', ['totoro']
      end
    end

    it 'uses a home path for defining a custom fixture' do
      result_block.should have_content('Totoro')
    end
  end
end