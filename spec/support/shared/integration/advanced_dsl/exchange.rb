shared_examples 'when a default fixture is exchanged' do
  context 'without a home path' do
    before do
      actor_without_home_path.public_send(action_method) do
        waiter :wait_for_max_and_zeus

        exchange ['tom'], ['max']
      end
    end

    it 'uses the exchanged fixture' do
      result_block.should have_content('Max')
      result_block.should have_content('Zeus')
    end
  end

  context 'with a home path' do
    before do
      actor_with_home_path.public_send(action_method) do
        exchange ['~/moris'], ['~/totoro']
      end
    end

    it 'uses the exchanged fixture which are stored in the sub directory' do
      result_block.should have_content('Totoro')
    end
  end
end