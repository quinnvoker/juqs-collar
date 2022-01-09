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

function scale_xy(xy, m) = let(nz_xy = sign(xy == 0 ? 1 : xy) * max(abs(xy), 0.0000001)) [ for (i = m) [i.x * nz_xy, i.y * nz_xy]];

function normalize(vec) = vec / norm(vec);

function grow(shape, mag) = [ for (i = shape) i + normalize(i) * mag];

function add_radius(shape, rad) = grow(shape, rad/cos(180/len(shape)));

function lerp(a,b,t) = a + (b - a) * t;

module round_poly(shape, radius, sharpness = 0){
    corner_r = lerp(radius, 0, sharpness);
    corner_offset = lerp(0, radius, sharpness);
    
    
    minkowski(){
        polygon(add_radius(scale_xy(0, shape),corner_offset));
        circle(max(corner_r, 0.0001));
    }
}


radius = 3;

round_poly(oct,radius, $t);