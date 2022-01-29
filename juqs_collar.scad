include<round_gates.scad>;
include<shape_gate.scad>;
include<shapes.scad>;

$fn = 100;

collar_r = 34.7/2;
//short_collar = 8.7;
short_collar = [8.7, [1.6, 0.5], false];
//full_collar = 18;
full_collar = [18, [4.6, 0.5], false];
stepped_collar = [8.7, [2.6, 0.5], true];
flush_collar = [8.7 + 5.8, [2.6, 0.5], false];
shaft_r = (9/2)/cos(180/$fn);
//shaft_r = 9/2;

throw_types = [
  [10, "B"],
  [10 / sqrt(2), "S"],
  [10 / sqrt(2 / 1.4), "SN"]
];

grommet_dist = 6.8; //distance the grommet sits below this component
grommet_depth = 6.4; //thickness of grommet (when compressed)
pivot_depth = grommet_dist + grommet_depth / 2;

VERSION = "V2.7";

CIR = "CIR";
SQR = "SQR";
OCT = "OCT";
OCTR = "OCTR";
OCTN = "OCTN";
SQRN = "SQRN";

juqs(model = OCTN, ver = VERSION, collar = flush_collar, throw_type= throw_types[2]);

/*
translate([40,0,0])
  juqs(model = SQR, ver = VERSION, collar = short_collar, throw_type= throw_types[0]);
translate([80,0,0])
  juqs(model = OCT, ver = VERSION, collar = short_collar, throw_type= throw_types[0]);
translate([0,-50,0]){
  juqs(model = OCTR, ver = VERSION, collar = short_collar, throw_type= throw_types[0]);
translate([40,0,0])
    juqs(model = OCTN, ver = VERSION, collar = short_collar, throw_type= throw_types[0]);
translate([80,0,0])
    juqs(model = SQRN, ver = VERSION, collar = short_collar, throw_type= throw_types[0]);
}
translate([0,-120,0]){
    juqs(model = CIR, ver = VERSION, collar = full_collar, throw_type= throw_types[0]);
translate([40,0,0])
  juqs(model = SQR, ver = VERSION, collar = full_collar, throw_type= throw_types[0]);
translate([80,0,0])
  juqs(model = OCT, ver = VERSION, collar = full_collar, throw_type= throw_types[0]);
translate([0,-50,0]){
  juqs(model = OCTR, ver = VERSION, collar = full_collar, throw_type= throw_types[0]);
translate([40,0,0])
    juqs(model = OCTN, ver = VERSION, collar = full_collar, throw_type= throw_types[0]);
translate([80,0,0])
    juqs(model = SQRN, ver = VERSION, collar = full_collar, throw_type= throw_types[0]);
}
}
*/

module juqs(model, ver, collar = short_collar, throw_type = throw_types[0]) {
  throw = throw_type[0];
  collar_h = collar[0];
  bevel = collar[1];
  stepped = collar[2];
  step_h = stepped ? 5.8 : 0;
  rotate([0,0,0]) {
    difference() {
      difference() {
        union() {
          base(b=0);
          collar(collar_h);
          if(stepped)
            collar(collar_h + step_h, 23.5 / 2);
        };
        bevels(collar_h + step_h, bevel[0], bevel[1]) {
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
            if(model == SQRN)
              sqrn_gate(throw, shaft_r);
          }
        }
      };
      /*
      font = "Open Sans:style=Bold";
      fontsize = 3.75;
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
      */
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

module base (size = [37.18, 37.12, 2.8], r = 8, b=0.30) {
  w = size.x;
  l = size.y;
  h = size.z;
  corner_offset = [w/2 - r, l/2 - r];
  hull() {
    translate([corner_offset.x, corner_offset.y, 0]){
      cylinder(b, r - b, r);
      translate([0,0,b])
        cylinder(h=h - b * 2, r=r);
      translate([0,0,h - b])
        cylinder(b, r, r - b);
    }
    translate([-corner_offset.x, corner_offset.y, 0]){
      cylinder(b, r - b, r);
      translate([0,0,b])
        cylinder(h=h - b * 2, r=r);
      translate([0,0,h - b])
        cylinder(b, r, r - b);
    }
    translate([corner_offset.x, -corner_offset.y, 0]){
      cylinder(b, r - b, r);
      translate([0,0,b])
        cylinder(h=h - b * 2, r=r);
      translate([0,0,h - b])
        cylinder(b, r, r - b);
    }
    translate([-corner_offset.x, -corner_offset.y, 0]){
      cylinder(b, r - b, r);
      translate([0,0,b])
        cylinder(h=h - b * 2, r=r);
      translate([0,0,h - b])
        cylinder(b, r, r - b);
    }
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
