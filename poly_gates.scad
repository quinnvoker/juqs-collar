gate_height = 50;

sq_poly = [
  [sqrt(2), sqrt(2)],
  [-sqrt(2), sqrt(2)],
  [-sqrt(2), -sqrt(2)],
  [sqrt(2), -sqrt(2)]
];

function scale_xy_z(m, xy, z) = [ for (i = [0 : len(m) - 1]) [m[i].x * xy, m[i].y * xy, z]];

function throw_end(throw) = gate_height * tan(throw);

function throw_points(shape, throw) = concat([[0,0,0]],scale_xy_z(shape, throw_end(throw), gate_height));

module shape_gate (shape, throw, shaft_r, sharpness = 1) {
  
}

//echo(concat([[0,0,0]],scale_xy_z(sq_poly, 3, 3)));

echo(throw_points(sq_poly, 15));
