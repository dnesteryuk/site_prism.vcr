require 'spec_integration_helper'

feature 'Applying VCR fixtures' do
  before do
    @test_app_page = TestAppPage.new
    @test_app_page.load
  end

  after do
    while VCR.eject_cassette
    end
  end

  context 'when an user clicks on the link which does an AJAX request' do
    before do
      @test_app_page.link_with_one_request.click_and_apply_vcr
      @test_app_page.wait_for_result_block
    end

    it 'should apply a fixture' do
      @test_app_page.result_block.should have_content('Octocat')
    end
  end

  context 'when a custom cassette is applied' do
    before do
      @test_app_page.link_with_one_request.click_and_apply_vcr(['octocus'], :replace)
      @test_app_page.wait_for_result_block
    end

    it 'should use a custom cassette instead of a default one for this element' do
      @test_app_page.result_block.should have_content('Octocus')
    end
  end

  context 'when there is a delay between clicking and doing an AJAX request' do
    before do
      @test_app_page.link_with_one_request_and_delay.click_and_apply_vcr
      @test_app_page.wait_for_result_block
    end

    it 'should apply a fixture' do
      @test_app_page.result_block.should have_content('Octocat')
    end
  end

  context 'when an user clicks on the link which does 2 AJAX requests' do
    before do
      @test_app_page.link_with_2_requests.click_and_apply_vcr
      @test_app_page.wait_for_result_block
    end

    it 'should apply 2 fixtures' do
      @test_app_page.result_block.should have_content('Octocat')
      @test_app_page.result_block.should have_content('Martian')
    end
  end
end