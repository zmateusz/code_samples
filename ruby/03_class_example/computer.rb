class Computer

  attr_accessor :hdd

  def initialize
    @hdd = 512
  end

  def info
    puts self.class
  end

  def score
    (2*@cpu + @ram/1024) * 10
  end

end
