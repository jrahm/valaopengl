BINARY?=opengltest
CC?=gcc
CFLAGS=-I/usr/include/glib-2.0 -I/usr/lib/glib-2.0/include -lgobject-2.0 -lglib-2.0 -I /usr/include/SDL
VALAFLAGS=--vapidir src/vapi/ --pkg sdl --pkg gl --pkg glu
VALAC?=valac
LDFLAGS=-lgobject-2.0 -lglib-2.0 -lSDL -lGL -lGLU
SOURCEDIR?=src
VALAHEADERDIR?=$(SOURCEDIR)/_include/
VALAVAPIDIR?=$(SOURCEDIR)/_vapi/
VALACDIR?=$(SOURCEDIR)/_c/
OBSDIR?=$(SOURCEDIR)/_obs/

all: init | build

init:
	mkdir -p $(VALACDIR) $(VALAHEADERDIR) $(VALAVAPIDIR) $(OBSDIR)

$(VALACDIR)/EventHandler.c: src/EventHandler.vala 
	$(VALAC) $(VALAFLAGS) --vapidir $(VALAVAPIDIR) --vapi $(VALAVAPIDIR)/EventHandler.vapi -H $(VALAHEADERDIR)/EventHandler.h -C src/EventHandler.vala 
	mv src/EventHandler.c $(VALACDIR)/EventHandler.c

$(OBSDIR)/EventHandler.o: $(VALACDIR)/EventHandler.c
	$(CC) -I$(VALAHEADERDIR) $(CFLAGS) -o $(OBSDIR)/EventHandler.o -c $(VALACDIR)/EventHandler.c

$(VALACDIR)/GLDrawable.c: src/GLDrawable.vala  $(VALACDIR)/EventHandler.c
	$(VALAC) $(VALAFLAGS) --vapidir $(VALAVAPIDIR) --vapi $(VALAVAPIDIR)/GLDrawable.vapi -H $(VALAHEADERDIR)/GLDrawable.h -C src/GLDrawable.vala  $(VALAVAPIDIR)/EventHandler.vapi
	mv src/GLDrawable.c $(VALACDIR)/GLDrawable.c

$(OBSDIR)/GLDrawable.o: $(VALACDIR)/GLDrawable.c
	$(CC) -I$(VALAHEADERDIR) $(CFLAGS) -o $(OBSDIR)/GLDrawable.o -c $(VALACDIR)/GLDrawable.c

$(VALACDIR)/SDLApplication.c: src/SDLApplication.vala  $(VALACDIR)/EventHandler.c $(VALACDIR)/GLDrawable.c
	$(VALAC) $(VALAFLAGS) --vapidir $(VALAVAPIDIR) --vapi $(VALAVAPIDIR)/SDLApplication.vapi -H $(VALAHEADERDIR)/SDLApplication.h -C src/SDLApplication.vala  $(VALAVAPIDIR)/EventHandler.vapi $(VALAVAPIDIR)/GLDrawable.vapi
	mv src/SDLApplication.c $(VALACDIR)/SDLApplication.c

$(OBSDIR)/SDLApplication.o: $(VALACDIR)/SDLApplication.c
	$(CC) -I$(VALAHEADERDIR) $(CFLAGS) -o $(OBSDIR)/SDLApplication.o -c $(VALACDIR)/SDLApplication.c

$(VALACDIR)/App.c: src/App.vala  $(VALACDIR)/EventHandler.c $(VALACDIR)/GLDrawable.c $(VALACDIR)/SDLApplication.c
	$(VALAC) $(VALAFLAGS) --vapidir $(VALAVAPIDIR) --vapi $(VALAVAPIDIR)/App.vapi -H $(VALAHEADERDIR)/App.h -C src/App.vala  $(VALAVAPIDIR)/EventHandler.vapi $(VALAVAPIDIR)/GLDrawable.vapi $(VALAVAPIDIR)/SDLApplication.vapi
	mv src/App.c $(VALACDIR)/App.c

$(OBSDIR)/App.o: $(VALACDIR)/App.c
	$(CC) -I$(VALAHEADERDIR) $(CFLAGS) -o $(OBSDIR)/App.o -c $(VALACDIR)/App.c

$(VALACDIR)/main.c: src/main.vala  $(VALACDIR)/EventHandler.c $(VALACDIR)/GLDrawable.c $(VALACDIR)/SDLApplication.c $(VALACDIR)/App.c
	$(VALAC) $(VALAFLAGS) --vapidir $(VALAVAPIDIR) --vapi $(VALAVAPIDIR)/main.vapi -H $(VALAHEADERDIR)/main.h -C src/main.vala  $(VALAVAPIDIR)/EventHandler.vapi $(VALAVAPIDIR)/GLDrawable.vapi $(VALAVAPIDIR)/SDLApplication.vapi $(VALAVAPIDIR)/App.vapi
	mv src/main.c $(VALACDIR)/main.c

$(OBSDIR)/main.o: $(VALACDIR)/main.c
	$(CC) -I$(VALAHEADERDIR) $(CFLAGS) -o $(OBSDIR)/main.o -c $(VALACDIR)/main.c

build:  $(OBSDIR)/EventHandler.o $(OBSDIR)/GLDrawable.o $(OBSDIR)/SDLApplication.o $(OBSDIR)/App.o $(OBSDIR)/main.o
	$(CC) $(LDFLAGS) -o $(BINARY)  $(OBSDIR)/EventHandler.o $(OBSDIR)/GLDrawable.o $(OBSDIR)/SDLApplication.o $(OBSDIR)/App.o $(OBSDIR)/main.o


clean:
	rm -rf $(VALACDIR) $(OBSDIR)

spotless: clean
	rm -rf $(VALAHEADERDIR) $(VALAVAPIDIR)

