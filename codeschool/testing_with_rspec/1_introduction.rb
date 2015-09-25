# LEVEL 1

# 1 Describe
# Lets start writing a specification for the Tweet class. 
# Write a describe block for the Tweet model without any examples inside it.

# tweet_spec.rb
describe Tweet do
end


# 2 It
# Now create a pending test called "can set status".

describe Tweet do
  it "can set status"  
end


# 3 Expectation
# Now let's write the example. Go ahead and instantiate a tweet,
# give it the status "Nom nom nom", and test the status has been 
# properly set to this value using an == equality matcher.

describe Tweet do
  it 'can set status' do
    tweet = Tweet.new(status: "Nom nom nom")
    tweet.status.should == "Nom nom nom"
  end
end


# 4 Matchers
# Using a predicate 'be' matcher, make sure that a tweet like "Nom nom nom"
# (which is not a reply because it doesn't start with an '@' sign) is public.

describe Tweet do
  it 'without a leading @ symbol should be public' do
    tweet = Tweet.new(status: 'Nom nom nom')
    tweet.should be_public
  end
end


# 5 Comparison Matchers
# Finish the example below to ensure that our tweet.status.length 
# is less than or equal to 140 characters. Use a be matcher in your spec.

describe Tweet do
  it 'truncates the status to 140 characters' do
    tweet = Tweet.new(status: 'Nom nom nom' * 100)
    tweet.status.length.should be <= 140
  end
end


# tweet.rb
class Tweet
  attr_accessor :status

  def initialize(options={})
    self.status = options[:status]
  end

  def public?
    self.status && self.status[0] != "@"
  end

  def status=(status)
    @status = status ? status[0...140] : status
  end
end
