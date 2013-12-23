// modules: sdl

using SDL;

public interface EventHandler : Object {
    public abstract void processEvent( Event event ) ;
}
