shared_examples 'when a home path is define' do
  shared_examples 'expects the custom fixture on the page' do
    it 'applies a stored fixture in the directory defined in the home path' do
      expect(test_app_page.cat_owner).to have_content('Bran Stark')
    end
  end

  context 'when no custom fixture is applied' do
    before do
      actor_with_home_path.public_send(action_method)
    end

    it 'applies a stored fixture in the directory defined in the home path' do
      expect(cat_owner).to have_content('Daenerys Targaryen')
    end
  end

  context 'when a custom fixture is applied' do
    before do
      actor_with_home_path.public_send(action_method) do
        fixtures ['~/bran_stark']
      end
    end

    it_behaves_like 'expects the custom fixture on the page'
  end

  context 'when a home path is used within the path helper method' do
    before do
      actor_with_home_path.public_send(action_method) do
        path '~/', ['bran_stark']
      end
    end

    it_behaves_like 'expects the custom fixture on the page'
  end

  context 'when a home path is directly defined in the block for applying fixtures' do
    before do
      actor_without_home_path.public_send(action_method) do
        home_path 'custom'

        fixtures ['~/bran_stark']
      end
    end

    it_behaves_like 'expects the custom fixture on the page'
  end
end