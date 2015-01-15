shared_examples 'when a shorcut path is define' do
    before do
      actor.public_send(action_method) do
        shortcut_path 'c', 'custom'

        fixtures [':c/bran_stark']
      end
    end

  it 'applies a stored fixture in the directory defined in the shorcut path' do
    expect(cat_owner).to have_content('Bran Stark')
  end
end