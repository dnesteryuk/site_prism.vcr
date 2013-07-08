shared_examples 'expecting the custom fixtures on the page' do
  it 'applies a custom fixture considering the defined home path' do
    test_app_page.cat_owner.should have_content('Bran Stark')
  end
end

shared_examples 'when a custom cassette is applied' do
  before do
    actor.public_send(action_method) do
      path 'custom', ['daenerys_targaryen']
    end
  end

  it 'uses a custom cassette instead of a default one for this element' do
    cat_owner.should have_content('Daenerys Targaryen')
  end
end