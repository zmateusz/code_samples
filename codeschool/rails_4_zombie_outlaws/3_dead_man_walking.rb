# LEVEL 3 Strong Parameters, Filters, and Remote Forms

# Strong Parameters
# We haven't upgraded our ZombiesController to use Rails 4 yet, and users
# are getting a ActiveModel::ForbiddenAttributesError when they try to create
# a new zombie. Can you update the controller to fix this? You'll need to 
# require the :zombie parameter hash, and permit the :name and :most_wanted 
# keys within that hash.

class ZombiesController < ApplicationController
  def show
    @zombie = Zombie.find(params[:id])
  end

  def new
    @zombie = Zombie.new
  end

  def create
    # zombie_params = params[:zombie]
    zombie_params = params.require(:zombie).permit(:name, :most_wanted)
    @zombie = Zombie.new(zombie_params)
    if @zombie.save
      redirect_to @zombie, notice: 'Created.'
    else
      render action: 'new'
    end
  end
end


# Strong Parameters II
# Refactor the controller so that create and update call a private method
# named zombie_params to check parameters.

class ZombiesController < ApplicationController
  before_action :set_zombie, only: [:show, :edit, :update, :destroy]

  def show; end

  def new
    @zombie = Zombie.new
  end

  def edit; end

  def create
    # zombie_params = params.require(:zombie).permit(:name, :most_wanted)
    @zombie = Zombie.new(zombie_params)
    if @zombie.save
      redirect_to @zombie, notice: 'Created.'
    else
      render action: 'new'
    end
  end

  def update
    # zombie_params = params.require(:zombie).permit(:name, :most_wanted)
    if @zombie.update(zombie_params)
      redirect_to @zombie, notice: 'Updated.'
    else
      render action: 'edit'
    end
  end

  private
  def zombie_params
    params.require(:zombie).permit(:name, :most_wanted)
  end
  def set_zombie
    @zombie = Zombie.find(params[:id])
  end
end


# Authenticity Tokens
# We've modified the Zombie form to use AJAX, but now clients without
# JavaScript support are getting ActionController::InvalidAuthenticityToken
# errors. We still need a remote form, though. Can you fix the error?

module ZombieOutlaws
  class Application < Rails::Application
    config.time_zone = 'Central Time (US & Canada)'
    config.action_view.embed_authenticity_token_in_remote_forms = true
  end
end


# LEVEL 3 Filters, Session, Custom Flash Types

# Controller Actions
# Most of the methods in this controller set the instance variables 
# they need, but we need to set the @reward instance variable for both 
# the edit and update methods. Ensure the set_reward method is called 
# before either of these two methods are run.

class RewardsController < ApplicationController
 before_action :set_reward, only: [:edit, :update]
  def index
    @rewards = Reward.all
  end

  def new
    @reward = Reward.new
  end

  def edit; end

  def create
    @reward = Reward.new(reward_params)

    if @reward.save
      redirect_to @reward, notice: 'Created.'
    else
      render action: 'new'
    end
  end

  def update
    if @reward.update(reward_params)
      redirect_to @reward, notice: 'Updated.'
    else
      render action: 'edit'
    end
  end

  private
  def set_reward
    @reward = Reward.find(params[:id])
  end

  def reward_params
    params.require(:reward).permit(:amount)
  end
end


# Custom Flash Types
# Each zombie has a custom saying that we want to display when the zombie
# is updated. Add a groan flash type to the ZombiesController. Then, in 
# the update method, set the new flash content to @zombie.groan.

class ZombiesController < ApplicationController
  before_action :set_zombie, only: [:show, :edit, :update, :destroy]
  add_flash_types :groan

  def show; end

  def edit; end

  def update
    if @zombie.update(zombie_params)
      redirect_to @zombie, groan: @zombie.groan
    else
      render action: 'edit'
    end
  end

  private
  def set_zombie
    @zombie = Zombie.find(params[:id])
  end

  def zombie_params
    params.require(:zombie).permit(:name, :most_wanted)
  end
end


# Custom Flash Types II
# Now, display the groan flash type in a paragraph element at the top
# of the show view for zombies.

<p>
  <%= flash[:groan] %>
  <strong>Name:</strong>
  <%= @zombie.name %>
</p>

<%= link_to 'Edit', edit_zombie_path(@zombie) %> |
<%= link_to 'Back', zombies_path %>
