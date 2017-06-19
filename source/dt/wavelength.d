module dtq.wavelength;
static import stl, dln;

dln.vec3 Wavelength_To_RGB ( float wave ) {
  return wave.Wavelength_To_XYZ.XYZ_To_RGB;
}

float[] Wavelength_To_XYZ ( float wave ) {
  float x; {
    float t1 = (wave - 442.0f) * ((wave < 442.0f) ? 0.0624f : 0.0374f),
          t2 = (wave - 599.8f) * ((wave < 599.8f) ? 0.0264f : 0.0323f),
          t3 = (wave - 501.1f) * ((wave < 501.1f) ? 0.0490f : 0.0382f);

    x =  0.362f * stl.exp(-0.5f * t1 * t1) +
         1.056f * stl.exp(-0.5f * t2 * t2) -
         0.065f * stl.exp(-0.5f * t3 * t3);
  }

  float y; {
    float t1 = (wave - 568.8f) * ((wave < 568.8f) ? 0.0213f : 0.0247f),
          t2 = (wave - 530.9f) * ((wave < 530.9f) ? 0.0613f : 0.0322f);

    y = 0.821f * stl.exp(-0.5f * t1 * t1) +
        0.286f * stl.exp(-0.5f * t2 * t2);
  }

  float z; {
    float t1 = (wave - 437.0f) * ((wave < 437.0f) ? 0.0845f : 0.0278f),
          t2 = (wave - 459.0f) * ((wave < 459.0f) ? 0.0385f : 0.0725f);

    z = 1.217f * stl.exp(-0.5f * t1 * t1) +
        0.681f * stl.exp(-0.5f * t2 * t2);
  }
  return [x, y, z];
}



static dln.vec3 XYZ_To_RGB(float[] xyz) {
  float proc ( float c ) {
      // clip if c is out of range
      c = c > 1.0f ? 1.0f : (c < 0.0f ? 0.0f : c);
      // colour component transfer
      return c <= 0.0031308f ? (c*12.92f) :
              (1.055f*stl.pow(c, 1.0f/2.4f) - 0.055f);
  }
  float x = xyz[0], y = xyz[1], z = xyz[2];

  float rl =  3.2406255f * x + -1.5372080f * y + -0.4986286f * z,
        gl = -0.9689307f * x +  1.8757561f * y +  0.0415175f * z,
        bl =  0.0557101f * x + -0.2040211f * y +  1.0569959f * z;
  return dln.vec3(proc(rl), proc(gl), proc(bl));
}
