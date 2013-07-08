shared_examples 'when a default fixture is exchanged' do
  context 'without a home path' do
    before do
      actor_without_home_path.public_send(action_method) do
        waiter :wait_for_arya_stark_and_robb_stark

        exchange 'ned_stark', 'arya_stark'
      end
    end

    it 'uses the exchanged fixture' do
      cat_owner.should have_content('Arya Stark')
      cat_owner.should have_content('Robb Stark')
    end
  end

  context 'with a home path' do
    before do
      actor_with_home_path.public_send(action_method) do
        exchange '~/daenerys_targaryen', '~/bran_stark'
      end
    end

    it 'uses the exchanged fixture which are stored in the sub directory' do
      cat_owner.should have_content('Bran Stark')
    end
  end
end