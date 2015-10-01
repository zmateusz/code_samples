# LEVEL 4

# Clean up your code with before
# Refactor the zombie spec to use a before hook.
# For bonus points refactor the examples to one line.

describe Zombie do
  let(:zombie) { Zombie.new }
  subject { zombie }
  before { zombie.eat_brains }

  it 'is not a dummy zombie' do
    # zombie.eat_brains
    should_not be_dummy
  end

  it 'is a genius zombie' do
    # zombie.eat_brains
    should be_genius
  end
end


# Nested before filters
# We've decided to refactor out the smart zombie into its own context.
# Add a before filter specific to this context that will make our smart zombie spec pass.

describe Zombie do
  let(:zombie) { Zombie.new }
  before { zombie.iq = 0 }
  subject { zombie }

  it { should be_dummy }

  context 'with a smart zombie' do
    # Add 'before' here
    before { zombie.iq = 3 }
    it { should_not be_dummy }
  end
end


# Nested before filters refactoring
# Refactor our last example so that there is another context called 
# 'with a dummy zombie'. Move the zombie.iq before filter inside this context.

describe Zombie do
  let(:zombie) { Zombie.new }
  subject { zombie }

  it { should be_dummy }

  context 'with a smart zombie' do
    before { zombie.iq = 3 }
    it { should_not be_dummy }
  end

  context 'with a dummy zombie' do
    before { zombie.iq = 0 }
    it { should_not be_genius }
  end
end


# Shared Examples
# Ripping out duplicated specs into a shared example can help DRY up
# your specs. Rip out the following specs into the shared example group
 # and update Zombie and Plant specs to use the shared example.

shared_examples_for 'the brainless' do
  it { should be_dummy }
  it { should_not be_genius }
end

describe Zombie do
  # let(:zombie) { Zombie.new }
  # subject { zombie }

  # it { should be_dummy }
  # it { should_not be_genius }
  it_behaves_like 'the brainless'
end

describe Plant do
  # let(:plant) { Plant.new }
  # subject { plant }

  # it { should be_dummy }
  # it { should_not be_genius }
  it_behaves_like 'the brainless'
end


# Metadata with filter
# Add the focus tag to the 'with a smart zombie' context block. 
# This way we can run $ rspec --tag focus and just run these examples.

describe Zombie do
  let(:zombie) { Zombie.new }
  subject { zombie }

  context 'with a dummy zombie' do
    before { zombie.iq = 0 }
    it { should be_dummy }
  end

  context 'with a smart zombie', focus: true do
    before { zombie.iq = 3 }
    it { should_not be_dummy }
  end
end


# Running filtered specs
# Run the rspec command that will run only the specs tagged 
# with dumb in the spec/models/zombie_spec.rb file.

# $ rspec --tag­ dumb spec/models/zombie_spec.rb 

describe Zombie do
  let(:zombie) { Zombie.new }
  subject { zombie }

  context 'with a dummy zombie', dumb: true do
    before { zombie.iq = 0 }
    it { should be_dummy }
  end

  context 'with a smart zombie' do
    before { zombie.iq = 3 }
    it { should_not be_dummy }
  end
end


# Running filtered specs
# Run the rspec command that will run all specs except those 
# tagged with dumb in the spec/models/zombie_spec.rb file.

# rspec --tag ~dumb spec/models/zombie_spec.rb


class Zombie < ActiveRecord::Base
  attr_accessible :name
  validates :name, presence: true

  def eat_brains
    self.iq += 3
  end

  def dummy?
    iq < 3
  end

  def genius?
    iq >= 3
  end
end

class Plant < ActiveRecord::Base
  def dummy?
    true
  end

  def genius?
    false
  end
end
