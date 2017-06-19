module pbmemitter;
static import stl;
import dln : vec3;

class PBMEmitter {
private:
  string filename;
  uint width, height;
  ubyte[] data;
  uint[] samples;
public:
  this ( string filename_, uint w, uint h ) {
    filename = filename_;
    width = w; height = h;
    data.length = 3*width*height;
    samples.length = width*height;
  }

  private auto RByteIndex ( uint w, uint h ) { return h*width*3 + w*3; }
  auto RIndex ( uint w, uint h ) { return h*width + w; }

  void Write ( uint w, uint h, vec3 rgb ) {
    auto bind = RByteIndex(w, h), ind = RIndex(w, h);
    auto slice = To_Vec3(data[bind .. bind+3]);
    auto m = TMix(rgb, slice, samples[ind]);
    data[bind .. bind+3] = To_Arr(m);
    ++ samples[ind];
  }

  auto Read ( uint w, uint h ) {
    auto ind = RByteIndex(w, h);
    return data[ind .. ind+3];
  }

  auto RWidth  ( ) { return width; }
  auto RHeight ( ) { return height; }

  void Flush ( ) {
    auto file = stl.File(filename, "wb");
    file.writef("P6\n%d %d\n255\n", width, height);
    foreach ( d; data ) file.writef("%c", cast(char)d);
  }
}

private auto TMix ( vec3 x, vec3 y, float a ) {
  a = a/(a+1.0f);
  auto e = x*(1.0f-a) + y*a;
  return e;
}


private auto To_Vec3(ubyte[] v) {
  auto V(T)(T x){ return cast(float)(x)/255.0f; }
  return vec3(V(v[0]), V(v[1]), V(v[2]));
}

private auto To_Arr(vec3 v) {
  auto V(T)(T x){ return cast(ubyte)(x*255.0f); }
  return [V(v.x), V(v.y), V(v.z)];
}
