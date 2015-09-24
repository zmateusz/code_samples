caffeineBuzz = (n) ->
  result = ""
  if n % 3 == 0
    if n % 4 == 0
      result = "Coffee"
      result += "Script" if n % 2 == 0
    else
      result = "Java"
      result += "Script" if n % 2 == 0
  else
    result = "mocha_missing!"
  result
