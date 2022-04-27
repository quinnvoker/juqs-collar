include<round_gates.scad>;
include<shape_gate.scad>;
include<shapes.scad>;
include<collar_types.scad>;

$fn = 100;

collar_r = 34.7/2;
shaft_r = (9/2)/cos(180/$fn);
//shaft_r = 9/2;

throw_types = [
  [10, "S"],
  [10 / sqrt(2), "SQ"],
  [10 / sqrt(2 / 1.4), "SN"]
];

grommet_dist = 6.8; //distance the grommet sits below this component
grommet_depth = 6.4; //thickness of grommet (when compressed)
pivot_depth = grommet_dist + grommet_depth / 2;

VERSION = "V3.1";

//hollow(OCTN, throw_types[2][0], shaft_r, pivot_depth);

juqs(model = OCTN, collar = FULL, throw_type= throw_types[2], production = true);

/*
color("red")
  translate([0,0,-pivot_depth])
    rotate([throw_types[2][0],0,0])
      cylinder(h = 100, r = shaft_r);
*/

module juqs(model = CIR, ver = VERSION, collar = SHORT, throw_type = throw_types[0], shaft_r = shaft_r, pivot_depth = pivot_depth, production = false) {
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
            collar(h = collar_h + step_h, r = 23.5 / 2, bevel =0.5);
        };
        inner_bevel(collar_h + step_h, bevel[1]) {
          hollow(model, throw, shaft_r, pivot_depth, collar_h + step_h, bevel);
       };
      };
      if(!production) {
        font = "Open Sans:style=Bold";
        fontsize = 4.2;
        translate([0,0,-0.1]) {
          mirror([1,0,0]) {
            linear_extrude(0.7){
              translate([0, 10.6, 0])
                text(str("JUQS"), font=font, size=fontsize, halign = "center");
              translate([0, -14.75, 0])
                text(str(ver, " ", throw_type[1]),font=font, size=fontsize, halign = "center");
            }
          };
        }
      }
    };
  };
};

module hollow(model = CIR, throw, shaft_r, pivot_depth, collar_h, bevel){
  translate([0,0,-pivot_depth]){
    if(model == CIR)
      cir_gate(throw, shaft_r);
    if(model == SQR)
      shape_gate(sqr_poly, throw, shaft_r, 0, collar_h, pivot_depth, bevel);
    if(model == OCT)
      shape_gate(oct_poly, throw, shaft_r, 0.5, collar_h, pivot_depth, bevel);
    if(model == OCTR)
      octr_gate(throw, shaft_r);
    if(model == OCTN)
      shape_gate(octn_poly, throw, shaft_r, 0.5, collar_h, pivot_depth, bevel);
    if(model == SQRN)
      qrn_gate(throw, shaft_r);
  }
}

module inner_bevel(collar_height, t_size = 0.8){
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
