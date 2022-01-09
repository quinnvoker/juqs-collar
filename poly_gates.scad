$fn = 32;
gate_height = 50;

include<math.scad>;
include<shapes.scad>;
include<round_poly.scad>;

function throw_travel(throw) = gate_height * tan(throw);

module shape_gate (shape, throw, shaft_r, sharpness = 0) {
  hull(){
    round_poly(shape, shaft_r, sharpness);
  }
}

shape_gate(sqr_poly, 10, 9 / 2, 1);
  
