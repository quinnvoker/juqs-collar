include<round_gates.scad>;
include<shape_gate.scad>;
include<shapes.scad>;

$fn = 100;

collar_r = 34.7/2;
short_collar = 8.7;
full_collar = 18;
shaft_r = (9/2)/cos(180/$fn);
//shaft_r = 9/2;

cardinal_throw = 9.6;

grommet_dist = 6.8; //distance the grommet sits below this component
grommet_depth = 6.4; //thickness of grommet (when compressed)
pivot_fix = 1; // amount to lower hollow pivot, to  prevent hitting low
pivot_depth = grommet_dist + grommet_depth / 2 + pivot_fix;

VERSION = "V1C";

CIR = "CIR";
SQR = "SQR";
OCT = "OCT";
OCTR = "OCTR";
OCTN = "OCTN";
OCTNR = "OCTNR";

juqs(model = OCTN, ver = VERSION, collar_h = short_collar);
//shaft(shaft_r, pivot_depth - pivot_fix, [0,cardinal_throw,0]);

module juqs(model, ver, collar_h = short_collar, throw = cardinal_throw) {
  rotate([0,0,0]) {
    difference() {
      difference() {
        union() {
          base();
          collar(collar_h);
        };
        bevels(collar_h, 1.8, 0.6) {
          translate([0,0,-pivot_depth]){
            if(model == CIR)
              cir_gate(throw, shaft_r);
            if(model == SQR)
              shape_gate(sqr_poly, throw, shaft_r);
            if(model == OCT)
              shape_gate(oct_poly, throw, shaft_r, 0.5);
            if(model == OCTR)
              octr_gate(throw, shaft_r);
            if(model == OCTN)
              shape_gate(octn_poly, throw, shaft_r, 0.5);
            if(model == OCTNR)
              octnr_gate(throw, shaft_r);
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
};

module bevels(collar_height, b_size = 0.8, t_size = 0.8){
  if(b_size > 0) {
    translate([0,0,-0.1])
      linear_extrude(b_size + 0.1) 
        projection(cut = true)
          translate([0,0,-b_size])
            children();
  }
  if(t_size > 0) {
    translate([0,0,collar_height - t_size])
      linear_extrude(height = t_size + 0.1, scale = 1 + 0.125 * (t_size + 0.1))
        projection(cut = true)
          translate([0,0,-(collar_height - t_size)])
            children();
  }
  children();
}

module shaft(r, depth, rotation) {
  translate([0,0,-depth]){
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
module collar (h = 8.7, r = (34.7/2), bevel = 1) {
  union() {
    cylinder(h=h - bevel, r=r);
    translate([0,0,h - bevel]) {
      cylinder(h=bevel, r1 = r, r2= r - bevel);
    }
  }
}
