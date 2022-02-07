$fn = 100;
gate_height = 50;

include<math.scad>;
include<round_poly.scad>;

module shape_gate (shape, throw, shaft_r, sharpness = 0) {
  function throw_travel(throw) = gate_height * tan(throw);

  hull(){
    translate([0,0, -(shaft_r / tan(throw))])
      linear_extrude(0.1)
        round_poly(shape, 0, 0, sharpness);
    translate([0,0,gate_height])
      linear_extrude(0.00001)
        round_poly(shape, shaft_r, throw_travel(throw), sharpness);
  }
}
