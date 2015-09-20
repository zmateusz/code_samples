module Hardware

  VER = 1.0

  def price
    puts @cpu*100 + @ram * 0.05
  end

  def self.status
    puts "Prices up to date."
  end

end
