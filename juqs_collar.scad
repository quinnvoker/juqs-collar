include<round_gates.scad>;
include<shape_gate.scad>;
include<shapes.scad>;

$fn = 100;

collar_r = 34.7/2;
//short_collar = 8.7;
short_collar = [8.7, [1.6, 0.5]];
//full_collar = 18;
full_collar = [18, [4.6, 0.5]];
shaft_r = (9/2)/cos(180/$fn);
//shaft_r = 9/2;

throw_types = [
    [9.45, "B"], //as close a match as possible to original Bandit design, originally achieved in "1E" revision, and cleaned up for "1G"
    [9.616, "9.616"],
    [9.75, "9.75"],
    [10, "10"],
];

grommet_dist = 6.8; //distance the grommet sits below this component
grommet_depth = 6.4; //thickness of grommet (when compressed)
pivot_fix = 1.7; // amount to lower hollow pivot, to  prevent hitting low
pivot_depth = grommet_dist + grommet_depth / 2 + pivot_fix;

VERSION = "V2.0";

CIR = "CIR";
SQR = "SQR";
OCT = "OCT";
OCTR = "OCTR";
OCTN = "OCTN";
OCTNR = "OCTNR";

juqs(model = CIR, ver = VERSION, collar = short_collar, throw_type= throw_types[1]);
//shaft(shaft_r, pivot_depth - pivot_fix, [0,cardinal_throw * sqrt(2) + 0.4, 45]);
//shaft(shaft_r, pivot_depth - pivot_fix, [0,cardinal_throw + 0.4, 0]);

module juqs(model, ver, collar = short_collar, throw_type = throw_types[0]) {
  throw = throw_type[0];
  collar_h = collar[0];
  bevel = collar[1];
  rotate([0,0,0]) {
    difference() {
      difference() {
        union() {
          base();
          collar(collar_h);
        };
        bevels(collar_h, bevel[0], bevel[1]) {
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
      font = "Open Sans:style=Bold";
      fontsize = 3.5;
      translate([0,0,-0.1]) {
        mirror([1,0,0]) {
          linear_extrude(0.7){
            translate([0, -11.75, 0])
                text(str("JUQS ",model), font=font, size=fontsize, halign = "center");
            translate([0, -16.75, 0])
              text(str(throw_type[1]," ",ver), font=font, size=fontsize, halign = "center");
          }
        };
      }
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

module base (size = [37.18, 37.12, 2.8], r = 8) {
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
