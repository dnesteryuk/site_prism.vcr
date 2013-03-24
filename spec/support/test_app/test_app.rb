require 'curb'
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

    http = Curl.get('https://api.github.com/users/octocat/orgs')
    http.body_str
  end

  get '/martian.json' do
    content_type :json

    http = Curl.get('https://api.github.com/users/martian/orgs')
    http.body_str
  end

  get '/' do
    erb :index
  end
end