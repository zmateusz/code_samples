require 'sinatra'
require 'json'

set :bind, '0.0.0.0'

before do
  content_type :json, charset: 'utf-8'
end

# READ / index
get '/camp/api/places' do
  begin
    data = File.read("json/page#{params['page'] || 1}.json")
    data = JSON.parse(data, symbolize_names: false).to_json
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
