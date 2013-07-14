shared_examples 'expecting the custom fixtures on the page' do
  it 'applies a custom fixture considering the defined home path' do
    expect(test_app_page.cat_owner).to have_content('Bran Stark')
  end
end

shared_examples 'when a custom cassette is applied' do
  before do
    actor.public_send(action_method) do
      path 'custom', ['daenerys_targaryen']
    end
  end

  it 'uses a custom cassette instead of a default one' do
    expect(cat_owner).to have_content('Daenerys Targaryen')
  end
end