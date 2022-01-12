sqr_poly = let() [
  [-1, -1],
  [1, -1],
  [1, 1],
  [-1, 1],
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

octn_poly = let(corner = 1 / sqrt(2 / 1.4))[
  [-corner, -corner],
  [0,-1],
  [corner, -corner],
  [1,0],
  [corner, corner],
  [0,1],
  [-corner, corner],
  [-1,0],
];

