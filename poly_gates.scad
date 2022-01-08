$fn = 32;
gate_height = 50;


sq_poly = let(corner = 1 / sqrt(2)) [
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

function scale_xy(xy, m) = [ for (i = m) [i.x * xy, i.y * xy]];

function add_z(z, m) = [ for (i = m) concat(i, z) ];

function throw_end(throw, base_offset) = base_offset + gate_height * tan(throw);

function throw_polygons(shape, throw, base_offset = 0) = [
  add_z(0, scale_xy(base_offset, shape)), 
  add_z(gate_height, scale_xy(throw_end(throw, base_offset), shape))
];

function throw_points(shape, throw, base_offset = 0) = let(polys = throw_polygons(shape, throw, base_offset)) [
  for(i = [0,len(polys) - 1]) each polys[i]
];

function throw_faces(points) = let(length = len(points), half = len(points) / 2) [
  [for(i = [0:half - 1]) i],
  [half, half + 1, 1, 0],
  [for(i = [length - 1:-1:half]) i],
  for(i = [1:half - 2]) [half + i, half + i + 1, i + 1, i],
  [length - 1, half, 0, half - 1]
];

function lerp(a,b,t) = a + (b - a) * t;

module shape_gate (shape, throw, shaft_r, sharpness = 0) {
  sharpness = lerp(1, shaft_r, sharpness);
  corner_r = shaft_r / sharpness;
  corner_offset = corner_r * (sharpness - 1);

  points = throw_points(shape, throw, corner_offset);
  echo(points);
  echo(corner_r);
  minkowski(){
    polyhedron(points, throw_faces(points));
    cylinder(1, corner_r);
  }
}

shape_gate(octn_poly, 10, 9.8 / 2, 0);
