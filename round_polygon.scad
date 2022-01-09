use<math.scad>;

module round_poly(shape, radius, size = 0, sharpness = 0){
  function grow(s, m) = [ for (i = s) i + normalize(i) * m];
  function add_radius(s, r) = grow(s, r/cos(180/len(s)));

corner_r = lerp(radius, 0, sharpness);
    corner_offset = lerp(0, radius, sharpness);
    
    minkowski(){
        polygon(add_radius(scale_xy(shape,size),corner_offset));
        circle(max(corner_r, 0.0001));
    }
}
