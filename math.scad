function normalize(vec) = vec / norm(vec);

function lerp(a,b,t) = a + (b - a) * t;

function scale_xy(shape, xy, allow_zero = false) = let(s = allow_zero ? xy : sign(xy == 0 ? 1 : xy) * max(abs(xy), 0.0001)) [ for (i = shape) [i.x * s, i.y * s]];

function add_z(z, m) = [ for (i = m) concat(i, z) ];
