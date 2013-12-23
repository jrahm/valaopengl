// vapidirs: src/vapi
// modules: sdl

using SDL ;
using GL ;
using Glox ;
using GLU ;

public class Application : Object, EventHandler, GLDrawable {
    private bool done = false ;
    private float angle = 0.0f ;
    private bool project_sig = true ;
    private float asp = 1.8f ;

    private void on_keyboard_event (KeyboardEvent event) {
    }

	public static string getString() {
		return "Hello, World!" ;
	}

    public void onEvent( Event event ) {
        switch ( event.type ) {
        case EventType.QUIT:
            done = true ;
            break ;
        case EventType.KEYDOWN:
            this.on_keyboard_event( event.key );
            break ;
        case EventType.VIDEORESIZE:
//            ResizeEvent evt = event.resize ;
//            stdout.printf("Resize Event2\n");
            break ;
        }
    }

    public bool update() {
        this.angle += 1.0f ;
        return done ;
    }

    public void draw() {
        glClear (GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
        glEnable( GL_DEPTH_TEST ) ;
        glLoadIdentity() ;

        gluLookAt( 0,0,1, 0,0,0, 0,1,0 ) ;
        preservingMatrix( () => {
            glRotatef( angle, 0, 1, 0 );
            glScalef( 0.2f, 0.2f, 0.2f ) ;
    
            glColor3f( 1,1,1 ) ;
            with( GL_QUADS, plotCube );
            glColor3f( 0,0,0 ) ;
            with( GL_LINES, plotCube );
        } );

        SDL.GL.swap_buffers() ;
    }
}
