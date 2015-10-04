# Level 1 Giddy up

# Match I
# The route definition in our routes file raises an error.
# Change the match method so that this route only responds
# to the POST HTTP method.

ZombieOutlaws::Application.routes.draw do
  post '/create_outlaws', to: 'zombies#create'
end


# Match II
# The following route is also raising an error. This time,
# don't change match method. Instead, pass additional options
# to the route so that it only responds to the GET HTTP method.

ZombieOutlaws::Application.routes.draw do
  match '/outlaws', to: 'zombies#outlaws', via: :get
end


# Match III
# We enjoy living on the edge, and we have a really good reason
# to allow all HTTP methods for the route in our routes file.
# Still, Rails 4 won't allow us to do that unless we explicitly
# tell it so. Fix this using the via options.

ZombieOutlaws::Application.routes.draw do
  match '/undeads', to: 'undeads#index', via: :all
end


# HTTP PATCH
# Update the following controller test to use the new HTTP verb
# for partial updates.

class WeaponsControllerTest < ActionController::TestCase
  test "updates weapon" do
    patch :update, zombie_id: @zombie, weapons: { name: 'Scythe' }
    assert_redirected_to zombie_url(@zombie)
  end
end


# Routing Concerns I
# Looks like there's a lot of duplication in our routes file.
# Extract the shotguns, rifles, and knives into a concern.
# Name this concern defensible, and reference it from 
# the three existing resources.

ZombieOutlaws::Application.routes.draw do
  concern :defensible do
    resources :shotguns
    resources :rifles
    resources :knives
  end
  
  resources :sheriffs, concerns: :defensible
  resources :gunslingers, concerns: :defensible
  resources :preachers, concerns: :defensible
end


# Routing Concerns - Part II
# We don't want to allow preachers to be able to destroy their
# defensible nested resources. First, make sure the defensible
# concern block takes an option. Then, make the preachers'
# defensible concern accept any method except destroy.

ZombieOutlaws::Application.routes.draw do
  concern :defensible do |options|
    resources :shotguns, options
    resources :rifles, options
    resources :knives, options
  end

  resources :sheriffs, concerns: :defensible
  resources :gunslingers, concerns: :defensible
  resources :preachers do
    concerns :defensible, except: :destroy
  end
end


# Thread Safety
# Change the production settings in our production environment
# file, from an application that's being upgraded to Rails 4,
# so that it's threadsafe. You will need to add two new settings.

ZombieOutlaws::Application.configure do
  config.cache_classes = true
  config.eager_load = true
end
