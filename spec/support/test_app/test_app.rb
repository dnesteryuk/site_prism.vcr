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

  get '/octocat.json' do
    content_type :json

    HTTPI.get(
      'https://api.github.com/users/octocat/orgs'
    ).body
  end

  get '/martian.json' do
    content_type :json

    HTTPI.get(
      'https://api.github.com/users/martian/orgs'
    ).body
  end

  get '/' do
    erb :index
  end

  get '/page_with_load' do
    erb :page_with_load
  end
end