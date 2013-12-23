// vapidirs: src/vapi
// modules: sdl

using SDL ;
using GL ;

public class Application : Object, EventHandler, GLDrawable {
    private bool done = false ;
    private float angle = 0.0f ;

//    private static bool is_alt_enter (Key key) {
//        return ((key.mod & KeyModifier.LALT)!=0)
//            && (key.sym == KeySymbol.RETURN
//                    || key.sym == KeySymbol.KP_ENTER);
//    }

    private void on_keyboard_event (KeyboardEvent event) {
    }

	public static string getString() {
		return "Hello, World!" ;
	}

    public void processEvent( Event event ) {
        switch ( event.type ) {
        case EventType.QUIT:
            done = true ;
            break ;
        case EventType.KEYDOWN:
            this.on_keyboard_event( event.key );
            break ;
        }
    }

    public bool update() {
        this.angle += 1.0f ;
        return done ;
    }

    public void draw() {
        glClear (GL_COLOR_BUFFER_BIT);

        glPushMatrix() ;
        glRotatef( angle, 0, 1, 0 );

        glBegin (GL_TRIANGLES);
            glVertex3f ( 0.0f, 1.0f, 0.0f);
            glVertex3f (-1.0f,-1.0f, 0.0f);
            glVertex3f ( 1.0f,-1.0f, 0.0f);
        glEnd ();

        glPopMatrix() ;

        SDL.GL.swap_buffers() ;
    }
}
