shared_examples 'clicks and handles one HTTP request' do
  before do
    test_app_page.link_with_one_request.click_and_apply_vcr
  end

  it 'applies a fixture' do
    expect(test_app_page.cat_owner).to have_content('Ned Stark')
  end
end