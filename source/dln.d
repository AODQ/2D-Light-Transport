module dln;
static import stl;
public import dlsl.vector;

struct Ray {
  vec2 origin, direction;
  this ( uint x, uint y ) {
    origin = vec2(x, y);
    direction = normalize(vec2(stl.uniform(-1.0f, 1.0f),
                               stl.uniform(-1.0f, 1.0f)));
  }
}
