import pbmemitter;
static import stl, dln;
import dln : vec2, vec3;
import std.stdio;
static import dt = dtq.dt;

class TestScene : dt.Scene {
  PBMEmitter emitter;

  this ( PBMEmitter emitter_ ) {
    emitter = emitter_;
  }
  dt.sdf.IntersectionInfo Map ( vec2 origin, uint ID ) inout {
    alias sdf = dt.sdf;
    auto info = sdf.Default_Info(ID);
    dt.bsdf.BSDF diffuse, specular;
    diffuse = new dt.bsdf.BSDF_Diffuse;
    specular = new dt.bsdf.BSDF_Specular;

    sdf.Union(info, sdf.sdSphere(origin - vec2(200.0f), 32.0f),
            diffuse, 1);
    sdf.Union(info, sdf.sdSphere(origin - vec2(480.0f, 330.0f), 32.0f),
            diffuse, 2);
    sdf.Union(info, sdf.sdSphere(origin - vec2(400.0f, 100.0f), 32.0f),
            diffuse, 3);

    // --- WALL ---
    sdf.Union(info, dln.dot(origin, vec2(0.0f,  1.0f))  - 5     , diffuse, 4);
    sdf.Union(info, dln.dot(origin, vec2(0.0f, -1.0f))  + 555.0f, diffuse, 5);
    sdf.Union(info, dln.dot(origin, vec2( 1.0f,  0.0f)) - 5     , diffuse, 6);
    sdf.Union(info, dln.dot(origin, vec2(-1.0f,  0.0f)) + 555.0f, diffuse, 7);
    return info;
  }

  dt.Light RRandom_Light ( ) inout {
    return new dt.Light(dt.Light.Type.Radial, 300.0f, 400.0f);
  }

  bool In_Bounds ( vec2 v ) {
    return !(v.x < 0 || v.y < 0 || v.x >= emitter.RWidth ||
             v.y >= emitter.RHeight);
  }

  void Send_Wave ( vec2 start, vec2 end, float wavelength ) {
    if ( !In_Bounds(start) || !In_Bounds(end) ) return;
    Bresenham_Line(cast(int)start.x, cast(int)start.y,
                   cast(int)end.x,   cast(int)end.y,
                   emitter, dt.wavelength.Wavelength_To_RGB(wavelength));
  }
}

void Bresenham_Line ( int x0, int y0, int x1, int y1, PBMEmitter emitter,
                      vec3 col ) {
  bool steep = false;
  if ( stl.abs(x0 - x1) < stl.abs(y0 - y1) ) {
    stl.swap(x0, y0);
    stl.swap(x1, y1);
    steep = true;
  }

  if ( x0 > x1 ) {
    stl.swap(x0, x1);
    stl.swap(y0, y1);
  }

  int dx = x1 - x0, dy = y1 - y0;
  int derr = stl.abs(dy)*2, err = 0, y = y0;
  foreach ( x; x0 .. x1 ) {
    if ( steep )
      emitter.Write(y, x, (col));
    else
      emitter.Write(x, y, (col));
    err += derr;
    if ( err > dx ) {
      y += (y1 > y0 ? 1 : -1);
      err -= dx*2;
    }
  }
}

void main() {
  static immutable W = 600, H = 800;
  auto em = new PBMEmitter("asdf.pbm", W, H);

  auto kernel = dt.Create_Kernel(new TestScene(em), 32, 2048);

  kernel.Run();

  writeln;
  writeln("writing to file");
  em.Flush();
}
