module dtq.dt;
static import scene = dtq.scene;
public import dtq.scene;
public static import sdf = dtq.sdf, bsdf = dtq.bsdf,
                     wavelength = dtq.wavelength;
public import dtq.lights;


auto Create_Kernel ( scene.Scene dt_scene, uint thread_amt, size_t samples ) {
  import dtq.threadmanager;
  return new ThreadKernel(dt_scene, thread_amt, samples);
}
