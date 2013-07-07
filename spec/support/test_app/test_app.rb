require 'httpi'
require 'sinatra/base'

class TestApp < Sinatra::Base
  set :root, File.dirname(__FILE__)

  get '/jquery.min.js' do
    File.read("#{root}/public/jquery.min.js")
  end

  get '/test.js' do
    File.read("#{root}/public/test.js")
  end

  get '/max.json' do
    content_type :json

    HTTPI.get(
      'https://api.github.com/users/max/orgs'
    ).body
  end

  get '/felix.json' do
    content_type :json

    HTTPI.get(
      'https://api.github.com/users/felix/orgs'
    ).body
  end

  get '/' do
    erb :index, locals: {click_on: nil}
  end

  get '/immediate-http-interactions/one-request' do
    erb :index, locals: {click_on: 'link_with_one_request'}
  end

  get '/immediate-http-interactions/two-requests' do
    erb :index, locals: {click_on: 'link_with_2_requests'}
  end

  get '/immediate-http-interactions/home-path' do
    erb :index, locals: {click_on: 'link_with_home_path'}
  end
end