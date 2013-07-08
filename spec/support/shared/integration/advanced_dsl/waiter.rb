shared_examples 'custom waiters' do
  context 'when a waiter is redefined' do
    before do
      actor.public_send(action_method) do
        fixtures ['arya_stark', 'jon_snow']

        waiter :wait_for_arya_stark_and_jon_snow
      end
    end

    it 'uses a custom waiter' do
      cat_owner.should have_content('Arya Stark')
      cat_owner.should have_content('Jon Snow')
    end

    it 'uses a default waiter after using the custom waiter' do
      actor.public_send(action_method)

      cat_owner.should have_content('Ned Stark')
      cat_owner.should have_content('Robb Stark')
    end
  end

  context 'when a block is used to define a custom waiter' do
    before do
      my_page = test_app_page

      actor.public_send(action_method) do
        fixtures ['arya_stark', 'jon_snow']

        waiter { my_page.wait_for_arya_stark_and_jon_snow }
      end
    end

    it 'uses a newly defined waiter' do
      cat_owner.should have_content('Arya Stark')
      cat_owner.should have_content('Jon Snow')
    end
  end
end

shared_examples 'when a default waiter is defined within a block' do
  before do
    actor.public_send(action_method)
  end

  it 'uses a default waiter' do
    cat_owner.should have_content('Ned Stark')
    cat_owner.should have_content('Robb Stark')
  end
end