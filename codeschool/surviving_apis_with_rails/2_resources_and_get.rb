# LEVEL 2 Resources and GET

# Integration Intro
# Integration tests help drive the design of our API endpoints and simulate 
# clients interacting with our application. Let’s start writing some integration
# tests for our humans resources.

# Tasks
# 1 Our API resources live under their own api subdomain constraint. 
# Add the proper setup code to add subdomain support for our integration tests.
# Remember, Rails uses example.com as the domain for test runs.

# 2 If you look inside of our test block, the first thing we must do is to
# issue a GET request to the humans resources URI.

# 3 Use assert_equal to check for a 200 - Success response status, 
# and refute_empty to check for a non-empty response body.

# test/integration/listing_humans_test.rb
class ListingHumansTest < ActionDispatch::IntegrationTest
  # setup code here
  setup { host! 'api.example.com' }

  test 'returns a list of humans' do
    # test code here
    get '/humans'
    assert_equal 200, response.status
    refute_empty response.body
  end
end

# config/routes.rb
SurvivingRails::Application.routes.draw do
  namespace :api, path: '/', constraints: {subdomain: 'api'} do
    resources :humans
  end
end


# Listing Resources
# Now that our initial integration tests are in place, it’s time to write some
# production code. Inside of API::HumansController#index, we’ll need to respond
# with a json representation of our humans and a 200 - Success status code.

# Tasks
# 1 Render a json representation of humans. Don’t worry about the status code right now.

# 2 Now let’s make sure the response includes a 200 - success status code.

# app/controllers/api/humans_controller.rb
module API
  class HumansController < ApplicationController
    def index
      humans = Human.all
      render json: humans, status: 200
    end
  end
end


# Test Listing Resources With Query Strings
# Let’s add the ability to filter the list of humans we get back from our API.
# Before we implement this feature, we’ll need to write some integration tests.

# Tasks
# 1 On the setup method, set the host to api.example.com.

# 2 Now, let’s create two humans. Set the first one’s name to Allan with 
# the brain_type set to large. Then set the second one’s name to John with 
# the brain_type set to small.

# 3 Issue a GET request to the humans resources URI and pass a query string 
# with brain_type set to small. Assert the response status code is 200 - Success.

# 4 Parse the response.body from json into a Ruby hash. Make sure John is 
# included in the body, and that Allan is not.

# test/integration/listing_humans_test.rb
class ListingHumansTest < ActionDispatch::IntegrationTest
  setup { host! 'api.example.com' }

  test 'returns a list of humans by brain type' do
    allan = Human.create(name: 'Allan', brain_type: 'large')
    john = Human.create(name: 'John', brain_type: 'small')
    get '/humans?brain_type=small'
    assert_equal 200, response.status
    humans = JSON.parse(response.body, symbolize_names: true)
    names = humans.collect {|h| h[:name] }
    assert_includes names, 'John'
    refute_includes names, 'Allan'
  end
end


# Resources With Filter
# Now it’s time to write production code and make our tests pass. 
# From API::HumansController#index, we need to check for a specific parameter
# sent via URI query strings.

# Tasks
# 1 Using the params object, check if brain_type is passed in as a parameter.
# If it is, then narrow down the list of humans to only those with that specific 
# brain_type. Don’t forget to assign the new result back to the humans variable.

# 2 Finally, render a json representation of humans with a 200 - Success* status code.

# app/controllers/api/humans_controller.rb
module API
  class HumansController < ApplicationController
    def index
      humans = Human.all
      if brain = params[:brain_type]
        humans = humans.where(brain_type: brain)
      end
      render json: humans, status: :ok
    end
  end
end


# Test Retrieving Data For One Human
# We will now add the ability to retrieve one specific human by its id.
# Let’s start with a test.

# Tasks
# 1 Create a Human named Ash. Issue a GET request to the humans’ show endpoint
# using Ash’s id, and assert that the response status is 200 - Success.

# 2 Parse the response.body and assert the name returned matches our recently
# created human. Check the test/test_helper.rb tab for a helper method 
# that might be useful.

# test/integration/listing_humans_test.rb
class ListingHumansTest < ActionDispatch::IntegrationTest
  setup { host! 'api.example.com' }

  test 'returns human by id' do
    ash = Human.create(name: 'Ash')
    get "/humans/#{ash.id}"
    assert_equal 200, response.status
    human = json(response.body)
    assert_equal ash.name, human[:name]
  end
end

# test/test_helper.rb
def json(body)
  JSON.parse(body, symbolize_names: true)
end


# Returning One Human
# With tests in place, now let’s implement the show action for our 
# API::HumansController. We’ll fetch a specific Human by its id and return 
# its JSON representation.

# Tasks
# 1 Find a Human by its id and render it back as JSON.

# 2 Respond with a 200 - Success status code.

# app/controllers/api/humans_controller.rb
module API
  class HumansController < ApplicationController
    def show
      human = Human.find(params[:id])
      render json: human, status: :ok
    end
  end
end


# Using curl to Issue Network Requests
# Use the curl command to issue a GET request to http://cs-zombies-dev.com:3000/humans

# $ curl http://cs-zombies-dev.com:3000/humans


# Curl With Query Strings
# Use curl to issue a similar GET request to http://cs-zombies-dev.com:3000/humans.
# This time, we also want to send along the brain_type value set to large using
# query string parameters.

# $ curl http://cs-zombies-dev.com:3000/humans?brain_type=large


# Displaying Response Headers
# Use curl with a specific argument so that it only shows response headers
# from a GET request to http://cs-zombies-dev.com:3000/humans.

# $ curl -I http://cs-zombies-dev.com:3000/humans
