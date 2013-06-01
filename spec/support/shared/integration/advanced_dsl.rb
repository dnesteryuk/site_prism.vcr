shared_examples 'expecting the custom fixtures on the page' do
  it 'applies a custom fixture considering the defined home path' do
    test_app_page.result_block.should have_content('Totoro')
  end
end