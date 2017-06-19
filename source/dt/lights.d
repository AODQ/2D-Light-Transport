module dtq.lights;
static import stl;
  import dln : vec2;

class Light {
  enum Type {
    Radial, Point
  }

  Type type;
  float x, y;

  this ( Type type_, float x_, float y_ ) {
    type = type_; x = x_; y = y_;
  }

  vec2 RRandom_Angle ( ) {
    switch ( type ) {
      default: assert(0);
      case Type.Radial:
        return vec2(stl.uniform(-1.0f, 1.0f), stl.uniform(-1.0f, 1.0f));
    }
  }
}

class PointLight : Light {
  float dx, dy;
  this ( float x_, float y_, vec2 n ) {
    super(Type.Point, x_, y_);
    dx = n.x; dy = n.y;
  }

  override vec2 RRandom_Angle ( ) {
    switch ( type ) {
      default: assert(false);
      case Type.Point: return vec2(dx, dy);
    }
  }
}
