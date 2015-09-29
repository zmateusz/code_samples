# LEVEL 3

# Implicit Subject
# Add the implicit subject rather than creating a new Zombie 
# and then simplify the example to use it { }

describe Zombie do
  # it 'should not be a genius' do
  #   zombie = Zombie.new
  #   zombie.should_not be_genius
  # end
  it { should_not be_genius }
end


# Its Attribute
# Refactor the following code to use its but use the same matcher.

describe Zombie do
  # it 'should have an iq of zero' do
  #   subject.iq.should == 0
  # end
  its(:iq) { should == 0 }
end


# Refactoring into Contexts
# Notice how we have two expectations on a zombie object with a high iq.
# We should clean this up by creating a context for the high iq zombie 
# and making that zombie the subject of that context. Next, refactor the two
# expectations to use the implicit subject that we learned about in the previous challenge.

describe Zombie do
  it { should_not be_genius }
  its(:iq) { should == 0 }

  # it "should be_genius with high iq" do
  #   zombie = Zombie.new(iq: 3)
  #   zombie.should be_genius
  # end

  # it 'should have a brains_eaten_count of 1 with high iq' do
  #   zombie = Zombie.new(iq: 3)
  #   zombie.brains_eaten_count.should == 1
  # end

  context "high IQ zombie" do
    subject { Zombie.new(iq: 3) }
    it { should be_genius }
    its(:brains_eaten_count) {should == 1}
  end
end


# Subject with Lets
# Rather than declaring our zombie directly in the subject block as we're doing here,
# move it into its own let named zombie and update the subject to reference this new zombie.

describe Zombie do
  let(:tweet) { Tweet.new }
  # subject { Zombie.new(tweets: [tweet]) }
  let(:zombie) { Zombie.new(tweets: [tweet]) }
  subject { zombie }

  its(:tweets) { should include(tweet) }
  its(:latest_tweet) { should == tweet } 
end


# Method as a subject
# Make the two small changes which will allow these two tests to pass.

describe Zombie do
  context "with high iq" do
     # let(:zombie) { Zombie.new(iq: 3, name: 'Anna') }
     let!(:zombie) { Zombie.create(iq: 3, name: 'Anna') }
     subject { zombie }

     it "should be returned with genius" do
       Zombie.genius.should include(zombie)
     end

     it "should have a genius count of 1" do     
       Zombie.genius.count.should == 1
     end
  end
end


class Tweet < ActiveRecord::Base
  belongs_to :zombie
end

class Zombie < ActiveRecord::Base
  attr_accessible :iq
  validates :name, presence: true
  has_many :tweets

  def genius?
    iq >= 3
  end

  def self.genius
    where("iq >= ?", 3)
  end

  def brains_eaten_count
    iq / 3
  end

  def latest_tweet
    self.tweets.first
  end
end
