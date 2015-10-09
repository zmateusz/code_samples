# LEVEL 3 Content Negotiation

# Testing with Mime Type
# It’s time to improve the way our API determines the best
# response representation for different types of clients.
# Let’s start by writing a test to ensure our API is able 
# to serve humans resources in JSON.

# Tasks
# 1 Issue a GET request to the humans resource URI. Use the proper request
# header to ask for the JSON Mime Type.

# 2 Assert that the response status is 200 - Success and the response
# Content-Type is set to JSON.

class ListingHumansTest < ActionDispatch::IntegrationTest
  test 'returns humans in JSON' do
    get '/humans', {}, {'Accept' => Mime::JSON}
    assert_equal 200, response.status
    assert_equal Mime::JSON, response.content_type
  end
end


# Using respond_to
# We will now move onto production code, where we will add the ability 
# to respond to different formats from our HumansController.

# Tasks
# 1 Call the respond_to method, which takes a block with a single argument
# named format.

# 2 Inside the block, use the format object to respond back with 
# humans in JSON format and with a 200 - Success status code.

# 3 Now use the format object to respond back with humans in XML format 
# and with a 200 - Success status code.

class HumansController < ApplicationController
  def index
    humans = Human.all
    respond_to do |format|
      format.json { render json: humans, status: :ok }
      format.xml { render xml: humans, status: :ok }
    end
  end
end


# Listing Mime Types
# Sometimes it’s useful to check for the different Mime Types supported 
# by our Rails application, especially when debugging!
# Type the code that lists all Mime Types registered in our app.

# $ Mime::SET


# Using Custom Headers with curl
# Use curl to issue a GET request to http://cs-zombies-dev.com:3000/humans.
# Make sure that application/json is specified as the the accepted Mime Type
# using a request header, and that only response headers are displayed.

# $ curl -IH 'Accept: application/json' http://cs-zombies-dev.com:3000/humans
