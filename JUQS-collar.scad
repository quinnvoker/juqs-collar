$fn = 300;

base_w = 37.16; //not sure why slightly asym, but both collars i measured had this
base_l = 37.1;
base_h = 2.8;
base_r = 8;
collar_r = 34.7/2;
collar_h = 8.7; // short collar: 8.7, full: 18
collar_bezel = 1;
collar_inner_corner_r = 9/2; //should roughly match shaft for best feel
collar_inner_r = 13.2/2; //inner radius at bottom of official collar is 13.2

max_throw_circle = 10;
max_throw_square = 14;

grommet_dist = 6.8; //distance the grommet sits below this component
grommet_depth = 6.4; //thickness of grommet (when compressed)
pivot_depth = grommet_dist + grommet_depth / 2;


module collar (h, r, bezel = 0) {
    union() {
        cylinder(h=h - bezel, r=r);
        translate([0,0,h - bezel]) {
            cylinder(h=bezel, r1 = r, r2= r - bezel);
        }
    }
}

module base (w, l, h, r) {
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



difference() {
difference() {
union() {
    base(base_w, base_l, base_h, base_r);
collar(collar_h, collar_r, collar_bezel);
};
//sq_hollow(collar_h, collar_inner_r, collar_inner_corner_r, max_throw_square);
//oct_hollow(collar_h, collar_inner_r, collar_inner_corner_r, max_throw_circle);
soct_hollow(collar_h, collar_inner_r, collar_inner_corner_r, max_throw_square);
//roct_hollow(collar_h, collar_inner_r, collar_inner_corner_r, max_throw_square);
//nroct_hollow(collar_h, collar_inner_r, collar_inner_corner_r, max_throw_square);
};

/*
translate([0, -13, -0.1]) {
font = "Open Sans:style=Bold";
    mirror([1,0,0]) {
linear_extrude(0.6)
    //text("QJ-SQR-V2", font=font, size=3.5, halign = "center");
    //text("QJ-OCT-V2", font=font, size=3.5, halign = "center");
    //text("QJ-OCS-V2", font=font, size=3.5, halign = "center");
    //text("QJ-OCR-V2", font=font, size=3.5, halign = "center");
    text("QJ-OCR-V2", font=font, size=3.5, halign = "center");
}
}
*/
};