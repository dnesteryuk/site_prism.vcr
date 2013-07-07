shared_examples 'custom waiters' do
  context 'when a waiter is redefined' do
    before do
      actor.public_send(action_method) do
        fixtures ['max', 'felix']

        waiter :wait_for_max_and_felix
      end
    end

    it 'uses a custom waiter' do
      result_block.should have_content('Max')
      result_block.should have_content('Felix')
    end

    it 'uses a default waiter after using the custom waiter' do
      actor.public_send(action_method)

      result_block.should have_content('Tom')
      result_block.should have_content('Zeus')
    end
  end

  context 'when a block is used to define a custom waiter' do
    before do
      my_page = test_app_page

      actor.public_send(action_method) do
        fixtures ['max', 'felix']

        waiter { my_page.wait_for_max_and_felix }
      end
    end

    it 'uses a newly defined waiter' do
      result_block.should have_content('Max')
      result_block.should have_content('Felix')
    end
  end
end

shared_examples 'when a default waiter is defined within a block' do
  before do
    actor.public_send(action_method)
  end

  it 'uses a default waiter' do
    result_block.should have_content('Tom')
    result_block.should have_content('Zeus')
  end
end