use<juqs_collar.scad>;
$fn = 100;

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
  union(){
    lower();
    translate([0, 0, 3.6])
      upper();
  }
}

module upper(solo = false, h = 4, size = 59.6, r = 3.5){
  difference() {
    rounded_rect(h = h, size = size, r = r);
    screw_holes();
    center_hole();
    translate([0,0,h - 2.8])
      base(b = 0);
    if(solo)
      guide_posts();
  }
}

module lower(solo = false, h = 3.6, size = 52.6, r = 15){
  difference() {
    union(){
      rounded_rect(h = h, size = size, r = r);
      if(solo)
        guide_posts();
    }
    screw_holes(r2 = 4.8/2);
    center_hole();
  }
}

module center_hole() {
  cylinder(h = 10, r = 35 / 2);
}

module guide_posts(h = 7.6, r = 6.5 / 2) {
  rotate([0,0,45])
    screw_holes(h = 7.6, r1 = r, r2 = r, pos = 61.8 / 2);
}

module screw_holes(h = 10, r1 = 4.8 / 2, r2 = 5.6 / 2, pos = 52.6 / 2 - 1.8){
  offset = pos - r1;
  chamfer_height = r2 - r1;
  translate([offset, 0, 0]){
    cylinder(h = h, r = r1);
    translate([0, 0 ,4 - chamfer_height])
      cylinder(h = chamfer_height, r1 = r1, r2 = r2);
  }
  translate([-offset, 0, 0]){
    cylinder(h = h, r = r1);
    translate([0, 0 ,4 - chamfer_height])
      cylinder(h = chamfer_height, r1 = r1, r2 = r2);
  }
  translate([0, offset, 0]){
    cylinder(h = h, r = r1);
    translate([0, 0 ,4 - chamfer_height])
      cylinder(h = chamfer_height, r1 = r1, r2 = r2);
  }
  translate([0, -offset, 0]){
    cylinder(h = h, r = r1);
    translate([0, 0 ,4 - chamfer_height])
      cylinder(h = chamfer_height, r1 = r1, r2 = r2);
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

