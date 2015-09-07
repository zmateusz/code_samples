require 'open-uri'
require 'json'
require 'net/http'

def get_places
  places = open("http://camp.efigence.com/camp/api/places/?page=1")
  response_status = places.status
  response_body = places.read
end

def save_file(data)
  File.open("json/page1.json", 'w') do |file|
    data = JSON.parse(data)
    data = JSON.pretty_generate(data)
    file.write data
  end
end

def open_file
  data = File.read("./json/page1.json")
  data = JSON.parse(data, symbolize_names: true)
end

def place_info(data, id)
  # id is Array element, not value of place 'id' key
  puts "Places in this file: #{data[:places].size}"
  place = data[:places][id]
  place.each {|k,v| puts "#{k}: #{v}"}
  puts "STATS: page: #{data[:page]} 
       total_pages: #{data[:total_pages]} 
       total_count: #{data[:total_count]}"
end

def post_contact
  uri = URI('http://camp.efigence.com/camp/api/contact')
  res = Net::HTTP.post_form(uri, "name":"John","email":"j@smith.com","message":"Hello!")
  # res.code, res.message
  response_body = res.body
end

# places = get_places
# save_file places
# places = open_file
# place_info(open_file, 0)
# post_contact
