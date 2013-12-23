// vapidirs: src/vapi
// modules: sdl gee-1.0

using SDL ;
using Gee ;
using GL ;
using GLU ;

public class SDLApplication : Object,EventHandler {
    private const int SCREEN_WIDTH = 640 ;
    private const int SCREEN_HEIGHT = 480 ;
    private const int DELAY = 10 ;

    private float asp ; 

    private unowned SDL.Screen screen ;
    private GLDrawable drawable ;
    private ArrayList<EventHandler> event_handlers;

    private bool done ;

    public SDLApplication () { 
        this.event_handlers = new ArrayList<EventHandler>() ;
        this.event_handlers.add( this ) ;
    }

    public float getAspectRatio() {
        return asp ;
    }

    public void setDrawable( GLDrawable draw ) {
        this.drawable = draw ;
    }

    public GLDrawable getDrawable( ) {
        return this.drawable ;
    }

    public void addEventHandler( EventHandler handler ) {
        this.event_handlers.add(handler);
    }

    private void reshape( int width, int height ) {
        this.asp = (height > 0) ? (float)width/height : 1 ;

        uint32 video_flags = SurfaceFlag.DOUBLEBUF
                           | SurfaceFlag.RESIZABLE
                           | SurfaceFlag.OPENGL ;

        this.screen = Screen.set_video_mode ( width, height, 0, video_flags );

        glViewport( 0,0, width, height ); 
        stdout.printf( "glViewport 0 0 %d %d\n", width, height ) ;

        glMatrixMode( GL_PROJECTION ) ;
        glLoadIdentity( ) ;
        gluPerspective( 50, asp, 0.5, 100 );
        glMatrixMode( GL_MODELVIEW ) ;
        glLoadIdentity();
    }

    private void init_video() {
        uint32 video_flags = SurfaceFlag.DOUBLEBUF
                           | SurfaceFlag.RESIZABLE
                           | SurfaceFlag.OPENGL ;

        this.screen = Screen.set_video_mode ( SCREEN_WIDTH, SCREEN_HEIGHT, 0, video_flags );
        if ( this.screen == null ) {
            stderr.printf("Could not set video mode.\n") ;
        }

        SDL.WindowManager.set_caption("Vala SDL/GL Demo", "");
        reshape( SCREEN_WIDTH, SCREEN_HEIGHT ) ;
    }

    public void run() {
        init_video() ;
        
        done = false ;
        while ( ! done ) {
            process_events() ;

            done = drawable.update() ;
            drawable.draw() ;

            SDL.Timer.delay( DELAY ) ;
        }
    }

    public void onEvent( Event event ) {
        if( event.type == EventType.VIDEORESIZE ) {
            stdout.printf("Resize Event\n");
            ResizeEvent evt = event.resize ;
            reshape(evt.w, evt.h) ;
        }
    }

    private void process_events() {
        Event event ;
        while ( Event.poll( out event ) == 1 ) {
            foreach ( var i in this.event_handlers ) {
                i.onEvent( event ) ;
            }
        }
    }
}
