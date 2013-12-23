BINARY?=hello
CC?=gcc
CFLAGS=-I/usr/include/glib-2.0 -I/usr/lib/glib-2.0/include -lgobject-2.0 -lglib-2.0 -w -I /usr/include/SDL -I /usr/include/gee-0.8
VALAFLAGS=--vapidir src/vapi/ --pkg sdl --pkg gl --pkg glu --pkg gee-0.8
VALAC?=valac
LDFLAGS=-lgobject-2.0 -lglib-2.0 -lSDL -lGL -lGLU -lgee-0.8
SOURCEDIR?=src
VALAHEADERDIR?=$(SOURCEDIR)/_include/
VALAVAPIDIR?=$(SOURCEDIR)/_vapi/
VALACDIR?=$(SOURCEDIR)/_c/
OBSDIR?=$(SOURCEDIR)/_obs/

all: init | build

init:
	mkdir -p $(VALACDIR) $(VALAHEADERDIR) $(VALAVAPIDIR) $(OBSDIR)

$(VALAVAPIDIR)/GLHelper.vapi: src/GLHelper.vala
	$(VALAC) --fast-vapi=$(VALAVAPIDIR)/GLHelper.vapi src/GLHelper.vala

$(VALACDIR)/GLHelper.c: src/GLHelper.vala
	$(VALAC) $(VALAFLAGS) --vapidir $(VALAVAPIDIR) --vapi $(VALAVAPIDIR)/GLHelper.vapi -H $(VALAHEADERDIR)/GLHelper.h -C src/GLHelper.vala 
	mv src/GLHelper.c $(VALACDIR)/GLHelper.c

$(OBSDIR)/GLHelper.o: $(VALACDIR)/GLHelper.c
	$(CC) -I$(VALAHEADERDIR) $(CFLAGS) -o $(OBSDIR)/GLHelper.o -c $(VALACDIR)/GLHelper.c

$(VALAVAPIDIR)/EventHandler.vapi: src/EventHandler.vala
	$(VALAC) --fast-vapi=$(VALAVAPIDIR)/EventHandler.vapi src/EventHandler.vala

$(VALACDIR)/EventHandler.c: src/EventHandler.vala
	$(VALAC) $(VALAFLAGS) --vapidir $(VALAVAPIDIR) --vapi $(VALAVAPIDIR)/EventHandler.vapi -H $(VALAHEADERDIR)/EventHandler.h -C src/EventHandler.vala  $(VALAVAPIDIR)/GLHelper.vapi
	mv src/EventHandler.c $(VALACDIR)/EventHandler.c

$(OBSDIR)/EventHandler.o: $(VALACDIR)/EventHandler.c
	$(CC) -I$(VALAHEADERDIR) $(CFLAGS) -o $(OBSDIR)/EventHandler.o -c $(VALACDIR)/EventHandler.c

$(VALAVAPIDIR)/GLDrawable.vapi: src/GLDrawable.vala
	$(VALAC) --fast-vapi=$(VALAVAPIDIR)/GLDrawable.vapi src/GLDrawable.vala

$(VALACDIR)/GLDrawable.c: src/GLDrawable.vala
	$(VALAC) $(VALAFLAGS) --vapidir $(VALAVAPIDIR) --vapi $(VALAVAPIDIR)/GLDrawable.vapi -H $(VALAHEADERDIR)/GLDrawable.h -C src/GLDrawable.vala  $(VALAVAPIDIR)/GLHelper.vapi $(VALAVAPIDIR)/EventHandler.vapi
	mv src/GLDrawable.c $(VALACDIR)/GLDrawable.c

$(OBSDIR)/GLDrawable.o: $(VALACDIR)/GLDrawable.c
	$(CC) -I$(VALAHEADERDIR) $(CFLAGS) -o $(OBSDIR)/GLDrawable.o -c $(VALACDIR)/GLDrawable.c

$(VALAVAPIDIR)/SDLApplication.vapi: src/SDLApplication.vala
	$(VALAC) --fast-vapi=$(VALAVAPIDIR)/SDLApplication.vapi src/SDLApplication.vala

$(VALACDIR)/SDLApplication.c: src/SDLApplication.vala
	$(VALAC) $(VALAFLAGS) --vapidir $(VALAVAPIDIR) --vapi $(VALAVAPIDIR)/SDLApplication.vapi -H $(VALAHEADERDIR)/SDLApplication.h -C src/SDLApplication.vala  $(VALAVAPIDIR)/GLHelper.vapi $(VALAVAPIDIR)/EventHandler.vapi $(VALAVAPIDIR)/GLDrawable.vapi
	mv src/SDLApplication.c $(VALACDIR)/SDLApplication.c

$(OBSDIR)/SDLApplication.o: $(VALACDIR)/SDLApplication.c
	$(CC) -I$(VALAHEADERDIR) $(CFLAGS) -o $(OBSDIR)/SDLApplication.o -c $(VALACDIR)/SDLApplication.c

$(VALAVAPIDIR)/App.vapi: src/App.vala
	$(VALAC) --fast-vapi=$(VALAVAPIDIR)/App.vapi src/App.vala

$(VALACDIR)/App.c: src/App.vala
	$(VALAC) $(VALAFLAGS) --vapidir $(VALAVAPIDIR) --vapi $(VALAVAPIDIR)/App.vapi -H $(VALAHEADERDIR)/App.h -C src/App.vala  $(VALAVAPIDIR)/GLHelper.vapi $(VALAVAPIDIR)/EventHandler.vapi $(VALAVAPIDIR)/GLDrawable.vapi $(VALAVAPIDIR)/SDLApplication.vapi
	mv src/App.c $(VALACDIR)/App.c

$(OBSDIR)/App.o: $(VALACDIR)/App.c
	$(CC) -I$(VALAHEADERDIR) $(CFLAGS) -o $(OBSDIR)/App.o -c $(VALACDIR)/App.c

$(VALAVAPIDIR)/main.vapi: src/main.vala
	$(VALAC) --fast-vapi=$(VALAVAPIDIR)/main.vapi src/main.vala

$(VALACDIR)/main.c: src/main.vala
	$(VALAC) $(VALAFLAGS) --vapidir $(VALAVAPIDIR) --vapi $(VALAVAPIDIR)/main.vapi -H $(VALAHEADERDIR)/main.h -C src/main.vala  $(VALAVAPIDIR)/GLHelper.vapi $(VALAVAPIDIR)/EventHandler.vapi $(VALAVAPIDIR)/GLDrawable.vapi $(VALAVAPIDIR)/SDLApplication.vapi $(VALAVAPIDIR)/App.vapi
	mv src/main.c $(VALACDIR)/main.c

$(OBSDIR)/main.o: $(VALACDIR)/main.c
	$(CC) -I$(VALAHEADERDIR) $(CFLAGS) -o $(OBSDIR)/main.o -c $(VALACDIR)/main.c

vapis:  $(VALAVAPIDIR)/GLHelper.vapi $(VALAVAPIDIR)/EventHandler.vapi $(VALAVAPIDIR)/GLDrawable.vapi $(VALAVAPIDIR)/SDLApplication.vapi $(VALAVAPIDIR)/App.vapi $(VALAVAPIDIR)/main.vapi

cfiles: vapis |  $(VALACDIR)/GLHelper.c $(VALACDIR)/EventHandler.c $(VALACDIR)/GLDrawable.c $(VALACDIR)/SDLApplication.c $(VALACDIR)/App.c $(VALACDIR)/main.c

objects: cfiles |  $(OBSDIR)/GLHelper.o $(OBSDIR)/EventHandler.o $(OBSDIR)/GLDrawable.o $(OBSDIR)/SDLApplication.o $(OBSDIR)/App.o $(OBSDIR)/main.o

build: objects
	$(CC) $(LDFLAGS) -o $(BINARY)  $(OBSDIR)/GLHelper.o $(OBSDIR)/EventHandler.o $(OBSDIR)/GLDrawable.o $(OBSDIR)/SDLApplication.o $(OBSDIR)/App.o $(OBSDIR)/main.o


clean:
	rm -rf $(VALACDIR) $(OBSDIR)

spotless: clean
	rm -rf $(VALAHEADERDIR) $(VALAVAPIDIR)


genmake:
	./valagenmake.sh

