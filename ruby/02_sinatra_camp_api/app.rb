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

  def validate(name, email, message) 
    errors = {}
    errors[:name] = ["nie może być puste"] if name.nil? || name.empty?
    email_errors = []
    email_errors << "nie może być puste" if email.nil? || email.empty?
    email_errors << "jest nieprawidłowe" if (email =~ /@/).nil?
    errors[:email] = email_errors if !email_errors.empty?
    errors[:message] = ["nie może być puste"] if message.nil? || message.empty?
    if errors.empty?
      {name: name, email: email, message: message}
    else
      {errors: errors}
    end
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
  data = validate(params[:name], params[:email], params[:message])
  if data.has_key?(:errors)
    status 422
    data.to_json
  else
    data.to_json
  end
end
