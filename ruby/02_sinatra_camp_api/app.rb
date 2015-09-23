require 'sinatra'
require "sinatra/reloader" if development?
require 'json'

set :bind, '0.0.0.0'

before '/camp/api/*' do
  content_type :json, charset: 'utf-8'
end

helpers do
  def read_file(page)
    data = File.read("json/page#{page}.json")
    data = JSON.parse(data, symbolize_names: false).to_json
  end
end

error 500 do
  "Server crashed for some " + env['sinatra.error'].message
end

# READ / index
get '/camp/api/places' do
  begin
    read_file(params['page'] || 1)
  rescue
    status 422
    "Unprocessable entity"
  end
end

# CREATE
# /camp/api/contact?name=John&email=j@j.com&message=Hello
post '/camp/api/contact' do 
  data = {name: params[:name],
          email: params[:email],
          message: params[:message]}.to_json
end
