module dtq.scene;
static import stl, dln, sdf = dtq.sdf;
import dtq.lights;

interface Scene {
public:
  sdf.IntersectionInfo Map ( dln.vec2 origin, uint prev_id ) inout;
  /// Returns a random light
  Light RRandom_Light ( ) inout;

  void Send_Wave ( dln.vec2 start, dln.vec2 end, float wavelength );
}
