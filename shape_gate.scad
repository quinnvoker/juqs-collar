$fn = 100;
gate_height = 28;

include<math.scad>;
include<round_poly.scad>;

module shape_gate (shape, throw, shaft_r, sharpness = 0, collar_h, pivot_depth, bevel) {
  function throw_travel(throw, height) = height * tan(throw);
  union(){
    translate([0,0, pivot_depth])
      linear_extrude(bevel[0] + 1)
      round_poly(shape, shaft_r, throw_travel(throw, pivot_depth + bevel[0]), sharpness);
    hull(){
      translate([0,0, pivot_depth + bevel[0]])
        linear_extrude(0.00001)
          round_poly(shape, shaft_r, throw_travel(throw, pivot_depth + bevel[0]), sharpness);
      translate([0,0,collar_h + pivot_depth - bevel[1]])
        linear_extrude(1)
          round_poly(shape, shaft_r, throw_travel(throw, pivot_depth + collar_h - bevel[1]), sharpness);
    }
  }
}
