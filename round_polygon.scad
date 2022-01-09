$fn=32;

card = 1;
corn = 1 / sqrt(2);

oct = [
    [card,0],
    [corn,corn],
    [0,card],
    [-corn,corn],
    [-card,0],
    [-corn,-corn],
    [0,-card],
    [corn,-corn]
];

function scale_xy(shape, xy, allow_zero = false) = let(s = allow_zero ? xy : sign(xy == 0 ? 1 : xy) * max(abs(xy), 0.0001)) [ for (i = shape) [i.x * s, i.y * s]];

function normalize(vec) = vec / norm(vec);

function grow(shape, mag) = [ for (i = shape) i + normalize(i) * mag];

function add_radius(shape, rad) = grow(shape, rad/cos(180/len(shape)));

function lerp(a,b,t) = a + (b - a) * t;

module round_poly(shape, radius, sharpness = 0){
    corner_r = lerp(radius, 0, sharpness);
    corner_offset = lerp(0, radius, sharpness);
    
    minkowski(){
        polygon(add_radius(scale_xy(shape,0),corner_offset));
        circle(max(corner_r, 0.0001));
    }
}


radius = 1;

round_poly(oct,radius, $t);