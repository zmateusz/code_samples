# LEVEL 1 Intro to REST

# Limiting Resources
# Our web API is exposing endpoints for the humans and weapons resources.
# Currently, all operations are allowed on these resources. However, if we want
# to make it through the Zombie Apocalypse, we need to be extremely careful
# about what operations we allow.

# Tasks
# 1 We cannot to allow the humans resources to be destroyed. 
# Add the option that prevents that from happening.

# 2 We must limit the operations allowed on the weapons 
# resources to :index and :show.

SurvivingRails::Application.routes.draw do
  resources :humans, except: :destroy
  resources :weapons, only: [:index, :show]
end


# Restricting Multiple Actions
# We’ve now changed our API to only allow listing resources for zombies,
# humans, medical_kits and broadcasts. Some unnecessary duplication is starting
# to smell, so now may be a good time to refactor our routes.

# Tasks
# 1 Refactor the current routes to use the with_options method. This method
# takes the options as the first argument and the resources definition
# as a block. Remember that the block takes one argument, which you will need
# to use in the resources definition.

# 2 Outside of the with_options block, create the messages resources 
# and prohibit access to the destroy action.

SurvivingRails::Application.routes.draw do
  with_options only: :index do |list|
    list.resources :zombies
    list.resources :humans
    list.resources :medical_kits
    list.resources :broadcasts
  end
  resources :messages, except: :destroy
end


# Constraints and Namespaces
# Our codebase is serving both a web API and a web site. Therefore, it is very
# important that we keep our code extremely organized. This helps mitigate 
# the risk of file conflicts, specially when multiple people work on 
# the same project.

# Tasks
# 1 Use the namespace method to create a namespace for api, and move 
# the zombies and humans resources into it.

# 2 Add a constraints option to our namespace and set its subdomain to api.

# 3 To avoid api being repeated on both the subdomain and on the URI path,
# add a path option to our namespace and set it to /.

SurvivingRails::Application.routes.draw do
  resources :announcements
  namespace :api, constraints: {subdomain: 'api'}, path: '/' do
    resources :zombies
    resources :humans
  end
end
