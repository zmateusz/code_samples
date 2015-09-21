unique = (integers) ->
  check = {}
  result = []
  for int in integers
    if check[int] is undefined
      check[int] = 1
      result.push int
  result
  