shared_examples 'when a default fixture is exchanged' do
  context 'without a home path' do
    before do
      actor_without_home_path.public_send(action_method) do
        waiter &:wait_for_arya_stark_and_robb_stark

        exchange 'ned_stark', 'arya_stark'
      end
    end

    it 'uses the exchanged fixture' do
      expect(cat_owner).to have_content('Arya Stark')
      expect(cat_owner).to have_content('Robb Stark')
    end
  end

  context 'with a defined home path' do
    context 'when fixtures are defined without Vcr options' do
      before do
        actor_with_home_path.public_send(action_method) do
          exchange '~/daenerys_targaryen', '~/bran_stark'
        end
      end

      it 'uses the exchanged fixture which are stored in the sub directory' do
        expect(cat_owner).to have_content('Bran Stark')
      end
    end

    context 'when fixtures are defined with Vcr options' do
      before do
        actor_with_home_path.public_send(action_method) do
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