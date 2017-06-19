module dtq.bsdf;
static import dln;
import util;

interface BSDF {
  enum Type { BRDF, BTDF };
  Type RRandom_Type ( );
  dln.vec2 BRDF ( dln.vec2 I, dln.vec2 N );
  dln.vec2 BTDF ( dln.vec2 I, dln.vec2 N );
  dln.vec3 RSellmeier_Coefficient_Refraction();
  dln.vec3 RSellmeier_Coefficient_Wavelength();
}


class BSDF_Diffuse : BSDF {
  Type RRandom_Type ( ) { return BSDF.Type.BRDF; }
  dln.vec2 BRDF ( dln.vec2 I, dln.vec2 N ) {
    return Reflect(I, N);
  }
  dln.vec2 BTDF ( dln.vec2 I, dln.vec2 N ) { assert(false); };
  dln.vec3 RSellmeier_Coefficient_Refraction ( ) {
    return dln.vec3(1.039612f, 0.23179f, 1.010469f);
  }
  dln.vec3 RSellmeier_Coefficient_Wavelength ( ) {
    return dln.vec3(0.6f, 0.2f, 0.01f);
  }
}

class BSDF_Specular : BSDF {
  Type RRandom_Type ( ) { return BSDF.Type.BTDF; }
  dln.vec2 BRDF ( dln.vec2 I, dln.vec2 N ) { assert(false); }
  dln.vec2 BTDF ( dln.vec2 I, dln.vec2 N ) {
    return Refract(I, N, 1.02f);
  }
  dln.vec3 RSellmeier_Coefficient_Refraction ( ) {
    return dln.vec3(1.039612f, 0.23179f, 1.010469f);
  }
  dln.vec3 RSellmeier_Coefficient_Wavelength ( ) {
    return dln.vec3(0.6f, 0.2f, 0.01f);
  }
}

class BSDF_Glossy {
}

class BSDF_Mixed {
}
