$fn = 32;
gate_height = 50;


sq_poly = let(corner = 1 / sqrt(2)) [
  [corner, corner],
  [-corner, corner],
  [-corner, -corner],
  [corner, -corner]
];

oct_poly = let(corner = 1 / sqrt(2))[
  [1,0],
  [corner, corner],
  [0,1],
  [-corner, corner],
  [-1,0],
  [-corner, -corner],
  [0,-1],
  [corner, -corner],
];

function scale_xy_z(m, xy, z) = [ for (i = [0 : len(m) - 1]) [m[i].x * xy, m[i].y * xy, z]];

function throw_end(throw) = gate_height * tan(throw);

function throw_points(shape, throw) = concat([[0,0,0]],scale_xy_z(shape, throw_end(throw), gate_height));

function throw_faces(points) = [
  [each [1:len(points) - 1]],
  for(i =[1:len(points) - 1]) let (next = i < len(points) - 1 ? i + 1 : 1) [i, next, 0] 
];

module shape_gate (shape, throw, shaft_r, sharpness = 1) {
  
}

//echo(concat([[0,0,0]],scale_xy_z(sq_poly, 3, 3)));

echo(throw_points(sq_poly, 15));
echo(throw_faces(throw_points(sq_poly, 15)));

points = throw_points(oct_poly, 15);
faces = throw_faces(points);

minkowski() {
hull(){
  polyhedron(points, faces);
}
cylinder(1,3);
}
