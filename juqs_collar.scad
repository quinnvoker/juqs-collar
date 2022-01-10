include<round_gates.scad>;
include<shape_gate.scad>;
include<shapes.scad>;

$fn = 32;

collar_r = 34.7/2;
short_collar = 8.7;
full_collar = 18;
shaft_r = 9/2; //should roughly match shaft for best feel
//inner radius at bottom of official collar is 13.2

cardinal_throw = 10;
max_throw_square = 14;

grommet_dist = 6.8; //distance the grommet sits below this component
grommet_depth = 6.4; //thickness of grommet (when compressed)
pivot_depth = grommet_dist + grommet_depth / 2;

VERSION = "V1B";

CIR = "CIR";
SQR = "SQR";
OCT = "OCT";
OCTR = "OCTR";
OCTN = "OCTN";
OCTNR = "OCTNR";

rotate([0,0,0]){
  /*
   * OCTNR corner test (seems to also match OCTN, nice!)
   * shaft(shaft_r, pivot_depth, [cardinal_throw+1.95,0,45]);
  */
  juqs(model = SQR, ver = VERSION, collar_h = short_collar);
}

module juqs(model, ver, collar_h = short_collar) {
  rotate([0,0,0]) {
    difference() {
      difference() {
        union() {
          base();
          collar(collar_h);
        };
        bevels(collar_h) {
          translate([0,0,-pivot_depth]){
            if(model == CIR)
              cir_gate(cardinal_throw, shaft_r);
            if(model == SQR)
              shape_gate(sqr_poly, cardinal_throw, shaft_r);
            if(model == OCT)
              shape_gate(oct_poly, cardinal_throw, shaft_r);
            if(model == OCTR)
              octr_gate(cardinal_throw, shaft_r);
            if(model == OCTN)
              shape_gate(octn_poly, cardinal_throw, shaft_r);
            if(model == OCTNR)
              octnr_gate(cardinal_throw, shaft_r);
          }
        }
      };
      translate([0, -11, -0.1]) {
        modtext = str("JUQS-",model);
        font = "Open Sans:style=Bold";
        fontsize = 3.75;
        mirror([1,0,0]) {
          linear_extrude(0.7){
            text(modtext, font=font, size=fontsize, halign = "center");
            translate([0, -5, 0])
              text(ver, font=font, size=fontsize, halign = "center");
          }
        };
      };
    };
  };
  //oct_hollow(cardinal_throw, shaft_r, pivot_depth);
};

module bevels(pivot_depth, collar_height, size = 1){
  translate([0,0,-0.1])
    linear_extrude(size + 0.1) 
      projection(cut = true)
        translate([0,0,-size])
          children();
  children();
}

module shaft(r, depth, rotation) {
  translate([0,0,-pivot_depth]){
    rotate(rotation)
      cylinder(h = 100, r = shaft_r);
  }
};

module base (size = [37.16, 37.1, 2.8], r = 8) {
  w = size.x;
  l = size.y;
  h = size.z;
  corner_offset = [w/2 - r, l/2 - r];
  hull() {
    translate([corner_offset.x, corner_offset.y, 0])
      cylinder(h=h, r=r);  
    translate([-corner_offset.x, corner_offset.y, 0])
      cylinder(h=h, r=r);  
    translate([corner_offset.x, -corner_offset.y, 0])
      cylinder(h=h, r=r);  
    translate([-corner_offset.x, -corner_offset.y, 0])
      cylinder(h=h, r=r);
  };
};

// use h=18 for full collar
module collar (h = 8.7, r = (34.7/2), bezel = 1) {
  union() {
    cylinder(h=h - bezel, r=r);
    translate([0,0,h - bezel]) {
      cylinder(h=bezel, r1 = r, r2= r - bezel);
    }
  }
}
