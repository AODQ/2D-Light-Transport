module dtq.kernel;
static import stl, dln, tm = dtq.threadmanager;
import util;
import stl : writeln;
import dln : vec2, vec3;
static import scene = dtq.scene, sdf = dtq.sdf, bsdf = dtq.bsdf;
import dtq.lights;

class DTKernel {
  stl.Tid owner;
  immutable(scene.Scene) dt_scene;
public:
  this ( stl.Tid owner_, inout(scene.Scene) dt_scene_ ) {
    owner = owner_;
    dt_scene = cast(immutable(scene.Scene))dt_scene_;
  }

  auto Generate_Path ( ) {
    struct PathInfo {
      bsdf.BSDF pbsdf;
      vec2 start, end;
      bool transmissive;
    }
    PathInfo[] path;

    auto light = dt_scene.RRandom_Light();
    vec2 ro = vec2(light.x, light.y), rd = light.RRandom_Angle;

    bool transmissive;
    bsdf.BSDF bsdf;
    uint march_id = -1;
    foreach ( i; 0 .. 4 ) {
      auto minfo = sdf.March(dt_scene, ro, rd, march_id);
      march_id = minfo.ID;
      if ( minfo.dist < 0.0f ) break;

      PathInfo tinfo = PathInfo(bsdf, ro, ro+minfo.dist*rd, transmissive);
      ro = tinfo.end;
      path ~= tinfo;
      if ( i == 4 ) break;
      // calculate BSDF
      auto normal = sdf.Normal(dt_scene, ro, march_id);
      bsdf = minfo.bsdf;
      transmissive = bsdf.RRandom_Type() == bsdf.BSDF.Type.BTDF;
      if ( transmissive ) {
        break;
        // rd = bsdf.BTDF(rd, normal);
      } else {
        rd = bsdf.BRDF(rd, normal);
      }
    }

    return path;
  }


  void Update ( ) {
    auto path = Generate_Path();
    foreach ( p; path )
      stl.send(owner, p.start, p.end, stl.uniform(300.0f, 900.0f));
  }
}
