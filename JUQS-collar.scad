$fn = 360;

collar_r = 34.7/2;
collar_h = 8.7; // short collar: 8.7, full: 18
shaft_r = 9/2; //should roughly match shaft for best feel
//inner radius at bottom of official collar is 13.2

cardinal_throw = 10;
max_throw_square = 14;

grommet_dist = 6.8; //distance the grommet sits below this component
grommet_depth = 6.4; //thickness of grommet (when compressed)
pivot_depth = grommet_dist + grommet_depth / 2;

VERSION = "V1A";

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
  juqs(model = OCTNR, ver = VERSION);
}

module juqs(model, ver) {
  rotate([0,0,0]) {
    difference() {
      difference() {
        union() {
          base();
          collar(collar_h);
        };
        if(model == CIR)
          cir_hollow(cardinal_throw, shaft_r, pivot_depth);
        if(model == SQR)
          sqr_hollow(max_throw_square, shaft_r, pivot_depth);
        if(model == OCT)
          oct_hollow(cardinal_throw, shaft_r, pivot_depth);
        if(model == OCTR)
          octr_hollow(cardinal_throw, shaft_r, pivot_depth);
        if(model == OCTN)
          octn_hollow(cardinal_throw, shaft_r, pivot_depth);
        if(model == OCTNR)
          octnr_hollow(cardinal_throw, shaft_r, pivot_depth);
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

module ci_pivot (throw, shaft_r) {
  h = 50;
  top_r = h * tan(throw) + shaft_r;
  cylinder(h = h, r1 = shaft_r, r2 = top_r);
}

module ci_bevel (throw, shaft_r, depth, b_height = 1) {
  cylinder(h = 50, r = shaft_r + (depth + b_height) * tan(throw));
}

module sq_pivot (throw, shaft_r, depth, sharpness = 1, throw_extend = 0) {  
  h = 50;
  shaft_r = shaft_r / sharpness;
  corner_offset = shaft_r * (sharpness - 1);
  translate([0,0,-depth]) {
    hull() {
      translate([corner_offset,0,0])
        rotate([0,throw,0])
          ci_pivot(throw = throw_extend, shaft_r = shaft_r);
      translate([-corner_offset,0,0])
        rotate([0,-throw,0])
          ci_pivot(throw = throw_extend, shaft_r = shaft_r);
      rotate([0,0,90]) {
        translate([corner_offset,0,0])
          rotate([0,throw,0])
            ci_pivot(throw = throw_extend, shaft_r = shaft_r);
        translate([-corner_offset,0,0])
          rotate([0,-throw,0])
            ci_pivot(throw = throw_extend, shaft_r = shaft_r);
      }
    };
  } 
}

module sq_bevel (throw, shaft_r, depth, sharpness = 1, throw_extend = 0, b_height = 1) {
  h = 50;
  shaft_r = shaft_r / sharpness;
  corner_offset = shaft_r * (sharpness - 1) + ((depth + b_height) * tan(throw));
  translate([0,0,-depth]) {
    hull() {
      translate([corner_offset,0,0])
        cylinder(h = h, r = shaft_r + (depth + b_height) * tan(throw_extend));
      translate([-corner_offset,0,0])
        cylinder(h = h, r = shaft_r + (depth + b_height) * tan(throw_extend));
      rotate([0,0,90]) {
        translate([corner_offset,0,0])
          cylinder(h = h, r = shaft_r + (depth + b_height) * tan(throw_extend));
        translate([-corner_offset,0,0])
          cylinder(h = h, r = shaft_r + (depth + b_height) * tan(throw_extend));
      }
    }
  }
}

module cir_hollow(slope, shaft_r, depth) {
  translate([0,0,-depth]) {
    ci_pivot(slope, shaft_r);
    ci_bevel(slope, shaft_r, depth);
  }
}

module sqr_hollow (slope, shaft_r, depth) {
  rotate([0,0,45]) {
    sq_pivot(slope, shaft_r, depth);
    sq_bevel(slope, shaft_r, depth);
  };
};

module oct_hollow (slope, shaft_r, depth) {
  hull() {
    rotate([0,0,45])
      sq_pivot(slope, shaft_r, depth);
    sq_pivot(slope, shaft_r, depth);
  }
  hull() {
    rotate([0,0,45])
      sq_bevel(slope, shaft_r, depth);
    sq_bevel(slope, shaft_r, depth);
  }
};

//work in progress
module octn_hollow (slope, shaft_r, depth) {
  hull(){
    rotate([0,0,45])
      sq_pivot(slope + 3, shaft_r, depth, 3);
    sq_pivot(slope, shaft_r, depth, 3);
  }
};

module octr_hollow (slope, shaft_r, depth) {
  union(){
    rotate([0,0,45])
      sq_pivot(slope, shaft_r, depth);
    sq_pivot(slope, shaft_r, depth);
  }
  union(){
    rotate([0,0,45])
      sq_bevel(slope, shaft_r, depth);
    sq_bevel(slope, shaft_r, depth);
  }
};

module octnr_hollow (slope, shaft_r, depth) {
  union(){
    rotate([0,0,45])
      sq_pivot(slope + 1, shaft_r, depth, 1, 1);
    sq_pivot(slope, shaft_r, depth);
  }
  union(){
    rotate([0,0,45])
      sq_bevel(slope + 1, shaft_r, depth, 1, 1);
    sq_bevel(slope, shaft_r, depth);
  }
};

module rotate_about_pt(rotation, pt) {
  translate(pt)
    rotate(rotation)
      translate(-pt)
        children();
};

