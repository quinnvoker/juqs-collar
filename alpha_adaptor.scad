use<juqs_collar.scad>;
/*
measurements

total_z = 7.6

upper_x = 59.6
upper_y = 59.6
upper_z = 4
upper_r = 2 // ? maybe

lower_x = 52.6
lower_y = 52.6
lower_z = 3.6
lower_r = 13 // ? maybe

screw_hole_d = 4.8
screw_hole_bevel_d = 8.2
screw_hole_bevel_h = 1.8
screw_hole_padding_lower = 1.8
*/

alpha_adaptor();

module alpha_adaptor() {
  $fn = 100;
  difference(){
    union(){
      lower();
      translate([0, 0, 3.6])
        upper();
    }
    screw_holes();
    cylinder(h = 10, r = 35 / 2);
    translate([0,0,7.6 - 2.8])
      base(b = 0);
  }
}

module upper(){
  rounded_rect(h = 4, size = 59.6, r = 2);
}

module lower(){
  rounded_rect(h=3.6, size = 52.6, r = 13);
}

module screw_holes(r = 4.8 / 2){
  offset = 52.6 / 2 - 1.8 - r;
  translate([offset, 0, 0]){
    cylinder(h = 10, r = r);
    translate([0, 0 ,7.6 - 1.8])
      cylinder(h = 1.8, r1 = r, r2 = 8.2 / 2);
  }
  translate([-offset, 0, 0]){
    cylinder(h = 10, r = r);
    translate([0, 0 ,7.6 - 1.8])
      cylinder(h = 1.8, r1 = r, r2 = 8.2 / 2);
  }
  translate([0, offset, 0]){
    cylinder(h = 10, r = r);
    translate([0, 0 ,7.6 - 1.8])
      cylinder(h = 1.8, r1 = r, r2 = 8.2 / 2);
  }
  translate([0, -offset, 0]){
    cylinder(h = 10, r = r);
    translate([0, 0 ,7.6 - 1.8])
      cylinder(h = 1.8, r1 = r, r2 = 8.2 / 2);
  }
}

module rounded_rect(h, size, r) {
 corner_offset = size / 2 - r;
 hull(){
  translate([corner_offset, corner_offset, 0])
    cylinder(h = h, r = r);
  translate([corner_offset, -corner_offset, 0])
    cylinder(h = h, r = r);
  translate([-corner_offset, corner_offset, 0])
    cylinder(h = h, r = r);
  translate([-corner_offset, -corner_offset, 0])
    cylinder(h = h, r = r);
 }
}

