gate_height = 50;

// ROUND GATES: CIR, OCTR, OCTNR
module pivot (throw, shaft_r) {
  top_r = gate_height * tan(throw) + shaft_r;
  cylinder(h = gate_height, r1 = shaft_r, r2 = top_r);
}
 
module pivot_square (throw, shaft_r, throw_extend = 0) {  
  hull() {
    rotate([0,throw,0])
      pivot(gate_height, throw_extend, shaft_r);
    rotate([0,-throw,0])
      pivot(gate_height, throw_extend, shaft_r);
    rotate([0,0,90]) {
      rotate([0,throw,0])
        pivot(gate_height, throw_extend, shaft_r);
      rotate([0,-throw,0])
        pivot(gate_height, throw_extend, shaft_r);
    }
  };
}

module cir_gate (throw, shaft_r) { 
  pivot(throw, shaft_r); 
}
module octr_gate (throw, shaft_r) {
  union(){
    rotate([0,0,45])
      pivot_square(throw, shaft_r);
    pivot_square(throw, shaft_r);
  }
};
module octnr_gate (throw, shaft_r) {
  union(){
    rotate([0,0,45])
      pivot_square(throw + 1, shaft_r, 1);
    pivot_square(throw, shaft_r);
  }
};
