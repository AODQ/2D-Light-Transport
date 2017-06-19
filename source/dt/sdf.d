module dtq.sdf;
import dtq.bsdf;
static import scene = dtq.scene, dln;
import dln : vec2;
import std.stdio;

struct IntersectionInfo {
  float dist;
  BSDF bsdf;
  uint ID;
}

auto Default_Info ( uint ID ) {
  return IntersectionInfo(float.max, null, ID);
}
void Union ( ref IntersectionInfo x, float d, BSDF b, uint ID ) {
  if ( x.dist > d && x.ID != ID )
    x = IntersectionInfo(d, b, ID);
}

auto sdSphere(vec2 o, float radius ) {
  return o.length - radius;
}

auto March ( inout (scene.Scene) dt_scene, vec2 ro, vec2 rd, uint ID ) {
  float dist = 0.0f;
  IntersectionInfo info;
  foreach ( i; 0 .. 512 ) {
    info = dt_scene.Map(ro + rd*dist, ID);
    if ( info.dist == 0.0f || info.dist > 2048.0f ) break;
    dist += info.dist;
  }
  if ( info.dist > 2048.0f ) {
    info.dist = -1.0f;
    return info;
  }
  info.dist = dist;
  return info;
}

vec2 Normal ( inout (scene.Scene) dt_scene, vec2 ro, uint ID ) {
  vec2 e = vec2(0.001f, 0.0f);
  return dln.normalize(vec2(
      dt_scene.Map(ro + e.xy, ID).dist - dt_scene.Map(ro - e.xy, ID).dist,
      dt_scene.Map(ro + e.yx, ID).dist - dt_scene.Map(ro - e.yx, ID).dist
  ));
}
