// vapidirs: src/vapi
// modules: sdl

using GL ;

namespace Glox {

    public delegate void Block() ;

    public void preservingMatrix( Block block ) {
        glPushMatrix() ;
        block() ;
        glPopMatrix() ;
    }

    public void with( GLenum en, Block block ) {
        glBegin( en ) ;
        block() ;
        glEnd() ;
    }

    public struct Point {
        private float x;
        private float y;
        private float z;

        public Point( float x, float y, float z ) {
            this.x = x;
            this.y = y;
            this.z = z;
        }

        public void plot( ) {
            glVertex3f(x,y,z);
        }
    }

    public void plotCube() {
        glVertex3f( 1.0f, 1.0f, 1.0f);
        glVertex3f( 1.0f, 1.0f,-1.0f);
        glVertex3f( 1.0f,-1.0f,-1.0f);
        glVertex3f( 1.0f,-1.0f, 1.0f);
        glVertex3f( 1.0f, 1.0f, 1.0f);
        glVertex3f( 1.0f, 1.0f,-1.0f);
        glVertex3f(-1.0f, 1.0f,-1.0f);
        glVertex3f(-1.0f, 1.0f, 1.0f);
        glVertex3f( 1.0f, 1.0f, 1.0f);
        glVertex3f( 1.0f,-1.0f, 1.0f);
        glVertex3f(-1.0f,-1.0f, 1.0f);
        glVertex3f(-1.0f, 1.0f, 1.0f);
        glVertex3f(-1.0f, 1.0f, 1.0f);
        glVertex3f(-1.0f, 1.0f,-1.0f);
        glVertex3f(-1.0f,-1.0f,-1.0f);
        glVertex3f(-1.0f,-1.0f, 1.0f);
        glVertex3f( 1.0f,-1.0f, 1.0f);
        glVertex3f( 1.0f,-1.0f,-1.0f);
        glVertex3f(-1.0f,-1.0f,-1.0f);
        glVertex3f(-1.0f,-1.0f, 1.0f);
        glVertex3f( 1.0f, 1.0f,-1.0f);
        glVertex3f( 1.0f,-1.0f,-1.0f);
        glVertex3f(-1.0f,-1.0f,-1.0f);
        glVertex3f(-1.0f, 1.0f,-1.0f);
    }
}
