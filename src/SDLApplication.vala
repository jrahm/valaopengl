// vapidirs: src/vapi
// modules: sdl

using SDL ;

public class SDLApplication : Object {
    private const int SCREEN_WIDTH = 640 ;
    private const int SCREEN_HEIGHT = 480 ;
    private const int DELAY = 10 ;

    private unowned SDL.Screen screen ;
    private GLDrawable drawable ;
    private EventHandler event_handler { get; set; }
    private bool done ;

    public SDLApplication () { }

    public void setDrawable( GLDrawable draw ) {
        this.drawable = draw ;
    }

    public GLDrawable getDrawable( ) {
        return this.drawable ;
    }

    public void setEventHandler( EventHandler handler ) {
        this.event_handler = handler ;
    }

    public EventHandler getEventHandler( ) {
        return this.event_handler ;
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

    private void process_events() {
        Event event ;
        while ( Event.poll( out event ) == 1 ) {
            event_handler.processEvent( event ) ;
        }
    }
}
