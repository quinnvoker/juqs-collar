$fn = 100;

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

module ci_pivot (throw, shaft_r, depth) {
  h = 50;
  top_r = h * tan(throw) + shaft_r;
  cylinder(h = h, r1 = shaft_r, r2 = top_r);
}

module sq_pivot (throw, shaft_r, depth, sharpness = 1, throw_extend = 0) {  
    h = 50;
    corner_r = shaft_r / sharpness;
    corner_offset = corner_r * (sharpness - 1);
    translate([0,0,-depth]) {
        hull() {
            translate([corner_offset,0,0]){
                rotate([0,throw,0]){
                    ci_pivot(throw = throw_extend, shaft_r = corner_r, depth = depth);
                }
            }
            translate([-corner_offset,0,0]){
                rotate([0,-throw,0]){
                    ci_pivot(throw = throw_extend, shaft_r = corner_r, depth = depth);
                }
            }
            rotate([0,0,90]){
                translate([corner_offset,0,0]){
                    rotate([0,throw,0]){
                        ci_pivot(throw = throw_extend, shaft_r = corner_r, depth = depth);
                    }
                }
                translate([-corner_offset,0,0]){
                    rotate([0,-throw,0]){    
                        ci_pivot(throw = throw_extend, shaft_r = corner_r, depth = depth);
                    }
                }
            }
        };
    } 
}

module sq_hollow (corner_r, slope) {
    rotate([0,0,45]) {
        sq_pivot(slope, corner_r, pivot_depth);
    }
};

module oct_hollow (corner_r, slope) {
    hull(){
        rotate([0,0,45]) {
            sq_pivot(slope, corner_r, pivot_depth);
        }
        sq_pivot(slope, corner_r, pivot_depth);
    }
};

module soct_hollow (corner_r, slope) {
    hull(){
        rotate([0,0,45]) {
            sq_pivot(slope + 2, corner_r, pivot_depth, 4);
        }
        sq_pivot(slope, corner_r, pivot_depth, 4);
    }
};

module roct_hollow (corner_r, slope) {
    union(){
        rotate([0,0,45]) {
            sq_pivot(slope, corner_r, pivot_depth);
        }
        sq_pivot(slope, corner_r, pivot_depth);
    }
};

module nroct_hollow (corner_r, slope) {
    //diag_r = corner_r * 1.075;
    union(){
        rotate([0,0,45]) {
            sq_pivot(slope + 1, corner_r, pivot_depth, 1, 1);
        }
        sq_pivot(slope, corner_r, pivot_depth);
    }
};

translate([0,0,-pivot_depth]){
  rotate([0,0,0]){
    cylinder(h = 100, r = collar_inner_corner_r);
  }
}

rotate([0,0,0]) {
difference() {
difference() {
union() {
    base();
    collar(false);
};
//sq_hollow(collar_inner_corner_r, max_throw_square);
//oct_hollow(collar_inner_corner_r, max_throw_circle);
//soct_hollow(collar_inner_corner_r, max_throw_circle);
//roct_hollow(collar_inner_corner_r, max_throw_circle);
nroct_hollow(collar_inner_corner_r, max_throw_circle);
//ci_pivot(max_throw_circle, collar_inner_corner_r, pivot_depth);
};
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
