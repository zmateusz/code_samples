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
    data = JSON.parse(data, symbolize_names: false)
  end

  def validate(name, email, message) 
    blank_msg = "nie może być puste"
    errors = {}
    errors[:name] = [blank_msg] if blank?(name)
    email_errors = []
    email_errors << blank_msg if blank?(email)
    email_errors << "jest nieprawidłowe" if (email =~ /@/).nil?
    errors[:email] = email_errors if !email_errors.empty?
    errors[:message] = [blank_msg] if blank?(message)
    if errors.empty?
      {name: name, email: email, message: message}
    else
      {errors: errors}
    end
  end

  def blank?(param)
    param.nil? || param.empty?
  end
end

error 500 do
  "Server crashed for some " + env['sinatra.error'].message
end

# READ / index
get '/camp/api/places' do
  begin
    read_file(params['page'] || 1).to_json
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
