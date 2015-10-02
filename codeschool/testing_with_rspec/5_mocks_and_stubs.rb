# LEVEL 5

# Stubbing
# 250

# Refactor the spec below to use stubs rather than hitting the database.

describe ZombieMailer do
  context '#tweet' do
    # let(:zombie) { Zombie.create(email: 'anything@example.org') }
    let(:zombie) { stub(email: 'anything@example.org') }
    let(:tweet) { stub(message: 'Arrrrgggghhhh', zombie: zombie) }

    subject { ZombieMailer.tweet(zombie, tweet) }
    its(:from) { should include('admin@codeschool.com') }
    its(:to) { should include(zombie.email) }
    its(:subject) { should == tweet.message }
  end
end

  # zombie.rb
  class Zombie < ActiveRecord::Base
  has_many :tweets
  validates :email, presence: true
  attr_accessible :email
  end
  
  # tweet.rb
  class Tweet < ActiveRecord::Base
  belongs_to :zombie
  validates :message, presence: true
  attr_accessible :message
  end

    class ZombieMailer < ActionMailer::Base
  def tweet(zombie, tweet)
  mail(:from => 'admin@codeschool.com',
  :to => zombie.email,
  :subject => tweet.message)
  end
  end

#   Named Stubs
# 250

# It's possible to give a stub a name by passing it in as the first parameter to the stub method. Name your zombie and tweet stubs :zombie and :tweet.
describe ZombieMailer do
  context '#tweet' do
    # let(:zombie) { stub(email: 'anything@example.org') }
    let(:zombie) { stub(:zombie, email: 'anything@example.org') }
    let(:tweet) { stub(:tweet, message: 'Arrrrgggghhhh') }

    subject { ZombieMailer.tweet(zombie, tweet) }
    its(:from) { should include('admin@codeschool.com') }
    its(:to) { should include(zombie.email) }
    its(:subject) { should == tweet.message }
  end
end

# Mocking
# 250

# Update the spec so that whenever a tweet is created, we verify that email_tweeter is called on the tweet object.

describe Tweet do
  context 'after create' do
    let(:zombie) { Zombie.create(email: 'anything@example.org') }
    let(:tweet) { zombie.tweets.new(message: 'Arrrrgggghhhh') }

    it 'calls "email_tweeter" on the tweet' do
      # pending
      tweet.should_receive(:email_tweeter)
      tweet.save
    end
  end
end

  # tweet.rb
  class Tweet < ActiveRecord::Base
  belongs_to :zombie
  validates :message, presence: true
  attr_accessible :message
  
  after_create :email_tweeter
  
  def email_tweeter
  ZombieMailer.tweet(zombie, self).deliver
  end
  private :email_tweeter
  end
  
  # zombie.rb
  class Zombie < ActiveRecord::Base
  has_many :tweets
  validates :email, presence: true
  attr_accessible :email
  end

# Mocking with a return value
# 250

# We've changed the code below so we're mocking ZombieMailer.tweet method instead of the entire method. There is still more to do to make this example work. First, finish the let(:mail) statement below by creating a stub with a deliver method that returns true.
# Then update the mock so the call to the tweet method returns the mail stub you created.
describe Tweet do
  context 'after create' do
    let(:zombie) { Zombie.create(email: 'anything@example.org') }
    let(:tweet) { zombie.tweets.new(message: 'Arrrrgggghhhh') }
    let(:mail) { stub(deliver: true) }

    it 'calls "tweet" on the ZombieMailer' do
      ZombieMailer.should_receive(:tweet).and_return(mail)
      tweet.save
    end
  end
end

# Checking Method Params
# 250

# We know that the ZombieMailer is being called now, but we aren't verifying the parameters. Update the spec to verify that the zombie and tweet are getting passed as parameters into the tweet method.
describe Tweet do
  context 'after create' do
    let(:zombie) { Zombie.create(email: 'anything@example.org') }
    let(:tweet) { zombie.tweets.new(message: 'Arrrrgggghhhh') }
    let(:mail) { stub(deliver: true) }

    it 'calls "tweet" on the ZombieMailer' do
      ZombieMailer.should_receive(:tweet).with(zombie, tweet).and_return(mail)
      tweet.save
    end
  end
end


# Verifying Delivery
# 250

# We've verified that the ZombieMailer is being called with the correct parameters, but not that deliver is being called on the resulting mail object. Complete the new example by stubbing out the ZombieMailer.tweet method and having it return mail. Then make sure that the deliver method is called on the mail object.
describe Tweet do
  context 'after create' do
    let(:zombie) { Zombie.create(email: 'anything@example.org') }
    let(:tweet) { zombie.tweets.new(message: 'Arrrrgggghhhh') }
    let(:mail) { stub(:mail, deliver: true) }

    it 'calls "tweet" on the ZombieMailer' do
      ZombieMailer.should_receive(:tweet).with(zombie, tweet).and_return(mail)
      tweet.save
    end

    it 'calls "deliver" on the mail object' do
      # pending
      ZombieMailer.stub(tweet: mail)
      ZombieMailer.tweet.should_receive(:deliver)
      tweet.save
    end
  end
end

# Message Counts
# 250

# Notice on the tweet.rb source that we're now emailing every zombie in the horde in our email_tweeter. Update the spec to verify that tweet is called exactly as many times as there are zombies.
describe Tweet do
  context 'after create' do
    let(:zombie) { Zombie.create(email: 'anything@example.org') }
    let(:tweet) { zombie.tweets.new(message: 'Arrrrgggghhhh') }
    let(:mail) { stub(:mail, deliver: true) }

    it 'calls "tweet" on the ZombieMailer as many times as there are zombies' do
      Zombie.stub(all: [stub, stub, stub])
      # ZombieMailer.should_receive(:tweet).and_return(mail)
      ZombieMailer.should_receive(:tweet).exactly(3).times.and_return(mail)
      tweet.save
    end
  end
end

  class Tweet < ActiveRecord::Base
  belongs_to :zombie
  validates :message, presence: true
  attr_accessible :message
  
  after_create :email_tweeter
  
  def email_tweeter
  Zombie.all.each do |zombie|
  ZombieMailer.tweet(zombie, self).deliver
  end
  end
  private :email_tweeter
  end

  class Zombie < ActiveRecord::Base
  has_many :tweets
  validates :email, presence: true
  attr_accessible :email
  end

    class ZombieMailer < ActionMailer::Base
  def tweet(zombie, tweet)
  mail(:from => 'admin@codeschool.com',
  :to => zombie.email,
  :subject => tweet.message)
  end
  end
  