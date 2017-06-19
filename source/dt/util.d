module util;
static import dln;
import dln : vec2, vec3;
import stl : writeln;

vec2 Refract(vec2 I, vec2 N, float ior) {
  import std.math : sqrt;
  auto dot = dln.dot(I, N);
  auto k = 1.0f - ior*ior*(1.0f - dot*dot);
  return k < 0.0f ? I : ior*I - (ior*dot + sqrt(k))*N;
}

vec2 Reflect ( vec2 I, vec2 N ) {
  return I - 2.0f*dln.dot(I, N)*N;
}
