module dtq.threadmanager;
static import dln, stl, scene = dtq.scene;
import std.stdio;

private void KI_Call( stl.Tid owner, inout(scene.Scene) dt_scene,
                      size_t samples ) {
  import dtq.kernel;
  auto dtkernel = new DTKernel(owner, dt_scene);
  for ( int i = 0; i != samples; ++ i ) {
    try {
      dtkernel.Update();
    } catch ( Exception e ) {
      writeln("Caught exception in kernel: ", e);
    }
    if ( samples > 4 )
      if ( i%(samples/4) == 0 ) stl.send(owner, "step");
  }
  stl.send(owner, "end");
}

import progress : Progress;
class ThreadKernel {
private:
  stl.Tid[] threads;
  Progress progress;
  scene.Scene dt_scene;
public:
  uint running_threads;
  this ( scene.Scene dt_scene_,  uint thread_amt_, size_t samples ) {
    dt_scene = dt_scene_;
    running_threads = thread_amt_;
    foreach ( i; 0 .. thread_amt_ )
      threads ~= stl.spawn(&KI_Call, stl.thisTid,
                            cast(immutable)dt_scene, samples);
    progress = new Progress(thread_amt_*5);
    progress.title = "Rendering";
  }

  void Run ( ) {
    uint[] samples;
    while ( true ) {
      stl.Thread.sleep(stl.dur!("msecs")(25));
      while ( stl.receiveTimeout(stl.dur!"msecs"(0),
        (string status) {
          switch ( status ) {
            default: break;
            case "end":
              -- running_threads;
            goto case;
            case "step":
              progress.next();
            break;
          }
        },
        (dln.vec2 start, dln.vec2 end, float wavelength) {
          dt_scene.Send_Wave(start, end, wavelength);
        }
      )) {}
      if ( running_threads == 0 ) return;
    }
  }
}
