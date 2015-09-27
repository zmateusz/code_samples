# LEVEL 2

# Installing RSpec
# In this level we'll start by getting you setup on a regular
# Ruby project, then move onto using RSpec within Rails.
# Let's start by installing the rspec gem from the console.

# $ gem install rspec


# Command Line
# With the RSpec gem installed, you will have access to the command line tool, rspec.
# RSpec has a few settings you can configure, so to help us get started,
# let's initialize this as an RSpec project. This will generate a placeholder for our RSpec configuration.

# $ rspec --init


# Rails Configuration
# Using rspec --init will setup RSpec within a ruby project,
# but for the rest of this course we'll be using RSpec within a Rails project.
# Run the rails generator to install RSpec into the current Rails project.

# $ rails generate rspec:install


# Running specs from the command line
# We now have a Rails project all setup and we've created spec/models/zombie_spec.rb for you.
# Run this spec from the command line with color on, and specify documentation format.

# $ rspec --color --format documentation spec/models/zombie_spec.rb


# Predicate Matchers
# Refactor the following spec to use an include matcher.

describe Zombie do
  it 'includes a tweet' do
    tweet = Tweet.new
    zombie = Zombie.new(tweets: [tweet])
    # zombie.tweets.first.should == tweet
    zombie.tweets.should include(tweet)
  end
end


# Change Matcher
# In the following example, we're checking to see that a method changes the state of a zombie.
# We need to make sure the zombie was in a specific state before and after the method is called.
# Refactor the following example to use the expect and change syntax.

describe Zombie do
  it 'gains 3 IQ points by eating brains' do
    zombie = Zombie.new
    # zombie.iq.should == 0
    # zombie.eat_brains
    # zombie.iq.should == 3
    expect { zombie.eat_brains }.to change { zombie.iq }.by(3)
  end
end


# Have Matcher
# We're verifying the count to be greater than 0, but we really could be using
# a have matcher here to verify that the zombie has exactly one tweet.
# Refactor the spec to use the have matcher.

describe Zombie do
  it 'increases the number of tweets' do
    zombie = Zombie.new(name: 'Ash')
    zombie.tweets.new(message: "Arrrgggggggghhhhh")
    # zombie.tweets.count.should > 0
    zombie.should have(1).tweets
  end
end


# Raises an Error
# Testing for exceptions is tricky business. 
# Refactor the spec below to use the raise_error matcher with an expect block.

describe Zombie do
  it 'raises a Zombie::NotSmartEnoughError if not able to make a decision' do
    zombie = Zombie.new
    # begin
    #   zombie.make_decision!
    # rescue Zombie::NotSmartEnoughError => e
    #   e.should be_an_instance_of(Zombie::NotSmartEnoughError)
    # end
    expect {zombie.make_decision!}.to raise_error {Zombie::NotSmartEnoughError}
  end
end


# tweet.rb
 class Tweet < ActiveRecord::Base
  attr_accessible :message
  belongs_to :zombie
  validates :message, presence: true
end

# zombie.rb
class Zombie < ActiveRecord::Base
  attr_accessible :name
  has_many :tweets
  validates :name, presence: true
  validates :iq, numericality: true

  class NotSmartEnoughError < StandardError; end

  def eat_brains
    self.iq += 3
  end

  def genius?
    iq >= 3
  end

  def make_decision!
    raise NotSmartEnoughError unless genius?
    return true
  end
end
