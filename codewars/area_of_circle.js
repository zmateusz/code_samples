var circleArea = function(radius) {
  if (radius > 0) {
    return parseFloat((Math.PI * Math.pow(radius, 2)).toFixed(2));
  } else {
    return false;
  };
};
