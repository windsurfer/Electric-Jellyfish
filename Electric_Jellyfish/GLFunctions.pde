// need to include this line to enable additive blending
import javax.media.opengl.*;
Boolean onOff;

void enableAdditiveBlending(Boolean tf)
{
  onOff = tf;
  if (onOff == true)
  {
    // get a handle to the gl object that's used by processing to draw to the screen
    GL gl = ( (PGraphicsOpenGL)g).gl;
  
    // enable blending  
    gl.glEnable( GL.GL_BLEND );
    // set the blend function to be additive blending
    gl.glBlendFunc( GL.GL_SRC_ALPHA, GL.GL_ONE );
    gl.glDisable( GL.GL_DEPTH_TEST ); 
  } 
}
