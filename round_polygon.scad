$fn=32;

scale = 1;
card = scale;
corn = scale / sqrt(2);

function scale_xy(xy, m) = [ for (i = m) [i.x * xy, i.y * xy]];

function normalize(vec) = vec / norm(vec);

function grow(shape, mag) = [ for (i = shape) i + normalize(i) * mag];

function add_radius(shape, rad) = grow(shape, rad/cos(180/len(shape)));

function lerp(a,b,t) = a + (b - a) * t;

module round_poly(shape, radius, sharpness = 0){
    corner_r = lerp(radius, 0, sharpness);
    corner_offset = lerp(0, radius, sharpness);
    
    
    minkowski(){
        polygon(add_radius(shape,corner_offset));
        circle(max(corner_r, 0.0001));
    }
}

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

radius = 1;

round_poly(oct,radius, 1);