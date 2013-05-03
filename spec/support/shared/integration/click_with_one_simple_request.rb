shared_examples 'clicks and handles one AJAX request' do
  before do
    @test_app_page.link_with_one_request.click_and_apply_vcr
  end

  it 'should apply a fixture' do
    @test_app_page.result_block.should have_content('Octocat')
  end
end