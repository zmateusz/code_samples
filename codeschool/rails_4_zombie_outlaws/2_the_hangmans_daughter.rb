# LEVEL 2 ActiveRecord Finders

# Dynamic Finders I
# Rewrite the code to use ActiveRecord::Relation's API 
# (the where method).

# Zombie.find_all_by_weapon('Chainsaw')
Zombie.where(weapon: 'Chainsaw')


# find_by I
# Change the code to use the new find_by method.

# Zombie.find_by_name('Ash')
Zombie.find_by(name: 'Ash')


# find_by II
# Change the code that currently takes two arguments 
# to use the new find_by method.

# Zombie.find_by_name_and_weapon('Ash', 'Chainsaw')
Zombie.find_by(name: 'Ash', weapon: 'Chainsaw')


# find_or_create_by
# Use the new find_or_create_by method on the Zombie class
# to get rid of this ugly conditional on the code.

class MostWantedController < ApplicationController
  def create
    # @zombie = Zombie.where(name: params[:name]).first
    # unless @zombie
    #   @zombie = Zombie.create(name: params[:name])
    # end
    @zombie = Zombie.find_or_create_by(name: params[:name])
    redirect_to @zombie
  end
end


# Update
# Let's use the new, and shorter, method for updating 
# attributes from a model.

# @zombie.update_attributes(@zombie_params)
@zombie.update(@zombie_params)


# Model.all
# Change the following code so that it doesn't use the deprecated scoped method.

class MostWantedController < ApplicationController
  def index
    # @zombies = Zombie.scoped
    @zombies = Zombie.all
    if params[:outlaws]
      @zombies = @zombies.outlaws
    end
  end
end

class Zombie < ActiveRecord::Base
  scope :outlaws, -> { where(weapon: 'Chainsaw') }
end


# LEVEL 2 ActiveModel

# Scopes
# The code in zombie.rb does not behave as expected.
# Fix the errors and deprecation warnings by using 
# the new scope syntax.

class Zombie < ActiveRecord::Base
  # scope :recent, where('killed_on > ?', 2.days.ago)
  # scope :outlaws, where(status: 'outlaw')
  scope :recent, -> { where('killed_on > ?', 2.days.ago) }
  scope :outlaws, -> { where(status: 'outlaw') }
end


# Model.none
# Let's refactor the model to return Deputy.none instead
# of an empty array when there are no zombies at large.

class Deputy < ActiveRecord::Base
  def self.zombie_counterforce
    if Zombie.at_large_count.zero?
      # []
      Deputy.none
    else
      Deputy.where(status: 'available')
    end
  end
end


# Relation#not
# The following code uses an ugly SQL snippet to build 
# a query that gets zombies who are not outlaws. It also 
# has a bug when the status is 'nil', generating the wrong SQL.
# Fix the code so that it not only works properly, 
# but also reads better.

# Zombie.where('status != ?', 'outlaw')
Zombie.where.not(status: 'outlaw')


# Relation#order
# Change the code to use the new order method syntax.

# Zombie.order('name DESC, killed_on DESC')
Zombie.order(name: :desc, killed_on: :desc)


# Relation#references I
# Using the references method, change the code so that 
# it doesn't generate a deprecation warning.

Weapon.includes(:zombies)
      .where("zombies.name = 'Ash'")
      .references(:zombies)


# Relation#references II
# Now without using references, change the code so that
# it doesn't generate a deprecation warning.

# Weapon.includes(:zombies).where("zombies.name = 'Ash'")
Weapon.includes(:zombies).where(zombies: {name: 'Ash'})
