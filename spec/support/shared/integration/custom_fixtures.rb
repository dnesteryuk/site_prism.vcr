shared_examples 'when a custom fixture is applied' do
  before do
    actor.public_send(action_method) do
      path 'custom', ['daenerys_targaryen']
    end
  end

  it 'uses a custom fixture instead of a default one' do
    expect(cat_owner).to have_content('Daenerys Targaryen')
  end
end