$fn = 30;

collar_r = 34.7/2;
collar_h = 8.7; // short collar: 8.7, full: 18
collar_inner_corner_r = 9/2; //should roughly match shaft for best feel
collar_inner_r = 13.2/2; //inner radius at bottom of official collar is 13.2

max_throw_circle = 10;
max_throw_square = 14;

grommet_dist = 6.8; //distance the grommet sits below this component
grommet_depth = 6.4; //thickness of grommet (when compressed)
pivot_depth = grommet_dist + grommet_depth / 2;


module rotate_about_pt(rotation, pt) {
  translate(pt)
    rotate(rotation)
      translate(-pt)
        children();
}

module collar (full = false, bezel = 1) {
    h = 8.7;
    r = 34.7/2;
    if(full) {
      h = 18;
    }
    union() {
        cylinder(h=h - bezel, r=r);
        translate([0,0,h - bezel]) {
            cylinder(h=bezel, r1 = r, r2= r - bezel);
        }
    }
}

module base (size = [37.16, 37.1, 2.8], r = 8) {
    w = size.x;
    l = size.y;
    h = size.z;
    corner_offset = [w/2 - r, l/2 - r];
    hull() {
        translate([corner_offset.x, corner_offset.y, 0]) {
            cylinder(h=h, r=r);  
        };
        translate([-corner_offset.x, corner_offset.y, 0]) {
            cylinder(h=h, r=r);  
        };
        translate([corner_offset.x, -corner_offset.y, 0]) {
            cylinder(h=h, r=r);  
        };
        translate([-corner_offset.x, -corner_offset.y, 0]) {
            cylinder(h=h, r=r);  
        };
    };
};

module ci_pivot (collar_h = 8.7, throw, shaft_r, depth, x_offset = 0, bev = 0.5) {
  bottom_r = (pivot_depth + bev) * tan(throw) + shaft_r;
  top_r = (collar_h - bev * 2) * tan(throw) + bottom_r;
  bevel_r = bev * tan(45) + top_r;
  union() {
    translate([0,0,-pivot_depth]) {
      cylinder(h = pivot_depth + bev, r = bottom_r);
    }
    translate([0,0,bev]) {
      cylinder(h = collar_h - bev * 2, r1 = bottom_r, r2 = top_r);
    }
    translate([0,0,collar_h - bev]) {
      cylinder(h = bev, r1 = top_r, r2 = bevel_r);
    }
    translate([0,0,collar_h]) {
      cylinder(h = 100, r1 = bevel_r);
    }
  }
}

module sq_pivot (throw, shaft_r, depth, sharpness = 1, height = 50) {  
    corner_r = shaft_r / sharpness;
    corner_offset = corner_r * (sharpness - 1);
    translate([0,0,-depth]) {
        hull() {
            translate([corner_offset,0,0]){
                rotate([0,throw,0]){
                    cylinder(h = height, r = corner_r);
                }
            }
            translate([-corner_offset,0,0]){
                rotate([0,-throw,0]){
                    cylinder(h = height, r = corner_r);
                }
            }
            rotate([0,0,90]){
                translate([corner_offset,0,0]){
                    rotate([0,throw,0]){
                        cylinder(h = height, r = corner_r);
                    }
                }
                translate([-corner_offset,0,0]){
                    rotate([0,-throw,0]){
                        cylinder(h = height, r = corner_r);
                    }
                }
            }
        };
    } 
}

module sq_pivot_bevel (throw, shaft_r, depth, sharpness = 1, offset = 0.03, height = 50) {
    dist = tan(throw)*depth;
    corner_r = shaft_r / sharpness;
    corner_offset = dist+(offset * throw) + corner_r * (sharpness - 1);
    hull() {
        translate([corner_offset,0,0]){
            cylinder(h = height, r = corner_r);
        }
        translate([-corner_offset,0,0]){
            cylinder(h = height, r = corner_r);
        }
        translate([0,corner_offset,0]){
            cylinder(h = height, r = corner_r);
        }
        translate([0,-corner_offset,0]){
            cylinder(h = height, r = corner_r);
        }
    };
}

module sq_hollow (h, r, corner_r, slope) {
    union(){
        rotate([0,0,45]) {
            sq_pivot(slope, corner_r, pivot_depth);
            sq_pivot_bevel(slope, corner_r, pivot_depth);
        }
    }
};

module oct_hollow (h, r, corner_r, slope) {
    hull(){
        rotate([0,0,45]) {
            sq_pivot(slope, corner_r, pivot_depth);
        }
        sq_pivot(slope, corner_r, pivot_depth);
    }
    hull(){
        rotate([0,0,45]) {
            sq_pivot_bevel(slope, corner_r, pivot_depth);
        }
        sq_pivot_bevel(slope, corner_r, pivot_depth);
    }
};

module soct_hollow (h, r, corner_r, slope) {
    hull(){
        rotate([0,0,45]) {
            sq_pivot(slope - 2, corner_r, pivot_depth, 2.5);
        }
        sq_pivot(slope - 4, corner_r, pivot_depth, 2.5);
    }
    /*
    hull(){
        rotate([0,0,45]) {
            sq_pivot_bevel(slope - 2, corner_r, pivot_depth, 3);
        }
        sq_pivot_bevel(slope - 4, corner_r, pivot_depth, 3);
    }
    */
};

module roct_hollow (h, r, corner_r, slope) {
    union(){
        rotate([0,0,45]) {
            sq_pivot(slope - 4, corner_r, pivot_depth);
        }
        sq_pivot(slope - 4, corner_r, pivot_depth);
    }
    union(){
        rotate([0,0,45]) {
            sq_pivot_bevel(slope - 4, corner_r, pivot_depth);
        }
        sq_pivot_bevel(slope - 4, corner_r, pivot_depth);
    }
};

module nroct_hollow (h, r, corner_r, slope) {
    diag_r = corner_r * 1.075;
    union(){
        rotate([0,0,45]) {
            sq_pivot(slope - 4, diag_r, pivot_depth);
        }
        sq_pivot(slope - 4, corner_r, pivot_depth);
    }
    union(){
        rotate([0,0,45]) {
            sq_pivot_bevel(slope - 4, diag_r, pivot_depth);
        }
        sq_pivot_bevel(slope - 4, corner_r, pivot_depth);
    }
};

translate([0,0,-pivot_depth]){
  rotate([0,max_throw_circle,0]){
    cylinder(h = 100, r = collar_inner_corner_r);
  }
}

difference() {
difference() {
union() {
    base();
    collar(false);
};
//sq_hollow(collar_h, collar_inner_r, collar_inner_corner_r, max_throw_square);
//oct_hollow(collar_h, collar_inner_r, collar_inner_corner_r, max_throw_circle);
//soct_hollow(collar_h, collar_inner_r, collar_inner_corner_r, max_throw_square);
//roct_hollow(collar_h, collar_inner_r, collar_inner_corner_r, max_throw_square);
//nroct_hollow(collar_h, collar_inner_r, collar_inner_corner_r, max_throw_square);
  ci_pivot(collar_h, max_throw_circle, collar_inner_corner_r, pivot_depth);
};

/*
translate([0, -13, -0.1]) {
font = "Open Sans:style=Bold";
    mirror([1,0,0]) {
linear_extrude(0.6)
    //text("QJ-SQR-V2", font=font, size=3.5, halign = "center");h = 8.7;
    //text("QJ-OCT-V2", font=font, size=3.5, halign = "center");
    //text("QJ-OCS-V2", font=font, size=3.5, halign = "center");
    //text("QJ-OCR-V2", font=font, size=3.5, halign = "center");
    text("QJ-OCR-V2", font=font, size=3.5, halign = "center");
}
}
*/
};
