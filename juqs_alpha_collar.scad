include<collar_types.scad>
use<juqs_collar.scad>;
$fn = 100;

/*
  Measurements

  grommet_z = 6.5
  collar_base_to_grommet_z = 7.6 - 2.8 = 4.8
  pivot depth = 6.5 / 2 + 4.8 = 8.05

  shaft_d = 7.2

  stock_collar_upper_d = 12.5

  stock_collar_height = 2.1
*/

throw_types = [
  [10.425, "A"],
  [10.425 / sqrt(2 / 1.4), "AN"]
];

juqs(model = OCTN, collar = STEPPED, throw_type = throw_types[1], shaft_r = (7.2/2)/cos(180/$fn));