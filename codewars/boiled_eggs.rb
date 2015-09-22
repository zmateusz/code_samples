def cooking_time(eggs)
  eggs / 8 * 5 + (eggs % 8 == 0 ? 0 : 5)
end
