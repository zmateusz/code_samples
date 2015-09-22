def sumDigits(number)
  number.abs.to_s.each_char.map {|x| x.to_i}.reduce(:+)
end
