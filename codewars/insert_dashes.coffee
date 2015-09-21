insertDash = (num) ->
  num = num.toString()
  result = ""
  for n, i in num #second param (i) is index of n
    if n % 2 is 1 and num[i+1] % 2 is 1 #get char in string like element in array
      result += "#{n}-"
    else
      result += n
  result
