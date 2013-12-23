/* We have to tell sytastic that
 * these are the files we are
 * including */

// modules: sdl
// vapidir: _vapi

public class Main {
    static int main( string[] args ) {
        SDLApplication sdlapp = new SDLApplication() ;
        var app = new Application() ;
        sdlapp.setDrawable( app ); 
        sdlapp.addEventHandler( app );
        sdlapp.run() ;

        return 0 ;
    }
}
