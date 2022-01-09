sqr_poly = let(corner = 1 / sqrt(2)) [
  [-corner, -corner],
  [corner, -corner],
  [corner, corner],
  [-corner, corner],
];

oct_poly = let(corner = 1 / sqrt(2))[
  [-corner, -corner],
  [0,-1],
  [corner, -corner],
  [1,0],
  [corner, corner],
  [0,1],
  [-corner, corner],
  [-1,0],
];

octn_poly = let(corner = 1 / sqrt(2 / 1.2))[
  [-corner, -corner],
  [0,-1],
  [corner, -corner],
  [1,0],
  [corner, corner],
  [0,1],
  [-corner, corner],
  [-1,0],
];

