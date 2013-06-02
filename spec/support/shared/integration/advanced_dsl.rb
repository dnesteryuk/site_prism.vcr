shared_examples 'expecting the custom fixtures on the page' do
  it 'applies a custom fixture considering the defined home path' do
    test_app_page.result_block.should have_content('Totoro')
  end
end

shared_examples 'when a custom cassette is applied' do
  before do
    actor.public_send(action_method) do
      path 'custom', ['octocus']
    end
  end

  it 'uses a custom cassette instead of a default one for this element' do
    result_block.should have_content('Octocus')
  end
end

shared_examples 'custom waiters' do
  context 'when a waiter is redefined' do
    before do
      actor.public_send(action_method) do
        fixtures ['octocat', 'martian']

        waiter :wait_for_octocat_and_martian
      end
    end

    it 'uses a custom waiter' do
      result_block.should have_content('Octocat')
      result_block.should have_content('Martian')
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
        fixtures ['octocat', 'martian']

        waiter { my_page.wait_for_octocat_and_martian }
      end
    end

    it 'uses a newly defined waiter' do
      result_block.should have_content('Octocat')
      result_block.should have_content('Martian')
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

shared_examples 'when a home path is define' do
  context 'when no custom fixture is applied' do
    before do
      actor.public_send(action_method)
    end

    it 'applies a fixture considering the defined home path' do
      result_block.should have_content('Octocus')
    end
  end

  context 'when a custom fixture is applied' do
    before do
      actor.public_send(action_method) do
        fixtures ['~/totoro']
      end
    end

    it_behaves_like 'expecting the custom fixtures on the page'
  end

  context 'when a home path is used while defining fixtures within some path' do
    before do
      actor.public_send(action_method) do
        path '~/', ['totoro']
      end
    end

    it_behaves_like 'expecting the custom fixtures on the page'
  end

  context 'when a home path is directly defined in the block' do
    it 'applies a fixture'
  end
end

shared_examples 'when a default fixture is exchanged' do
  before do
    actor.public_send(action_method) do
      waiter :wait_for_octocat_and_zeus

      exchange ['tom'], ['octocat']
    end
  end

  it 'uses the exchanged fixture' do
    result_block.should have_content('Octocat')
    result_block.should have_content('Zeus')
  end

  it 'uses the exchanged fixture which are stored in the sub directory'
end