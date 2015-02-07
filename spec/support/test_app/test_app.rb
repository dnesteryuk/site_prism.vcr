require 'httpclient'
require 'sinatra/base'

class TestApp < Sinatra::Base
  set :root, File.dirname(__FILE__)

  get '/jquery.min.js' do
    File.read("#{root}/public/jquery.min.js")
  end

  get '/test.js' do
    File.read("#{root}/public/test.js")
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

  get '/max.json' do
    content_type :json

    http_request(
      "http://#{request.host}:#{request.port}/api/cat/max"
    ).body
  end

  get '/felix.json' do
    content_type :json

    http_request(
      "http://#{request.host}:#{request.port}/api/cat/felix"
    ).body
  end

  get '/api/cat/max' do
    content_type :json

    {
      cat_owner: 'Arya Stark',
      cat_name:  'Max'
    }.to_json
  end

  get '/api/cat/felix' do
    content_type :json

    {
      cat_owner: 'Jon Snow',
      cat_name:  'Felix'
    }.to_json
  end

  def http_request(url)
    client = HTTPClient.new
    client.get(
      url
    )
  end
end