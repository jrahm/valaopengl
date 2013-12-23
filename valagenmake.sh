function setup_variable {
    temp=$1
    eval 'temp=$'$temp
    if [[ $temp ]] && [[ $3 != "h" ]] ; then
        next=$temp
    else
        next=$2
    fi

    if [[ $3 == 'h' ]] ; then
        # hard set, no option
        echo $1'='$next>&3
    else
        echo $1'?='$next>&3
    fi
}

function setup_variables_vala {
    if [[ ! $BINARY ]] ; then
        echo "BINARY variable not defined"
        exit 1 ;
    fi

    for i in $(echo $VALAPACKAGES) ; do
        VALAFLAGS="$VALAFLAGS --pkg $i"
    done

    setup_variable "BINARY" ""
    setup_variable "CC" "gcc"
    setup_variable "CFLAGS" "-I/usr/include/glib-2.0 -I/usr/lib/glib-2.0/include -lgobject-2.0 -lglib-2.0 $CFLAGS" h
    setup_variable "VALAFLAGS" "$VALAFLAGS" h
    setup_variable "VALAC" "valac"
    setup_variable "LDFLAGS" "-lgobject-2.0 -lglib-2.0 $LDFLAGS" h

    # the source directory
    setup_variable "SOURCEDIR" .

    # This is where the byproducts of compilation go
    setup_variable "VALAHEADERDIR" '$(SOURCEDIR)/_include/'
    setup_variable "VALAVAPIDIR" '$(SOURCEDIR)/_vapi/'
    setup_variable "VALACDIR" '$(SOURCEDIR)/_c/'
    setup_variable "OBSDIR" '$(SOURCEDIR)/_obs/'
}

function generate_vala {
    setup_variables_vala
    
    echo -e ''>&3
    echo -e 'all: init | build'>&3
    echo -e ''>&3
    
    echo -e 'init:'>&3
    echo -e '\tmkdir -p $(VALACDIR) $(VALAHEADERDIR) $(VALAVAPIDIR) $(OBSDIR)'>&3
    echo -e ''>&3
    
    cfiles=''
    objects=''
    vapis=''
    for i in $SOURCES ; do
        noext=$(echo $i | sed 's/\.vala$//g')
        basename=$(basename $noext) 
    
        header='$(VALAHEADERDIR)/'$basename'.h'
        cfile='$(VALACDIR)/'$basename'.c'
        vapi='$(VALAVAPIDIR)/'$basename'.vapi'
        object='$(OBSDIR)/'$basename'.o'

        echo -e "$vapi: $i">&3
        echo -e '\t$(VALAC) --fast-vapi='$vapi' '$i>&3
        echo -e ''>&3
    
        # depends on vala source
        echo -e "$cfile: $i">&3
        echo -e '\t$(VALAC) $(VALAFLAGS) --vapidir $(VALAVAPIDIR) --vapi '$vapi' -H '$header' -C '$i' '$vapis>&3
        echo -e '\t'mv $noext'.c '$cfile>&3
        echo -e ''>&3

        echo -e "$object: $cfile">&3
        echo -e '\t$(CC) -I$(VALAHEADERDIR) $(CFLAGS) -o '$object' -c '$cfile>&3
        echo -e ''>&3

        cfiles="$cfiles $cfile"
        objects="$objects $object"
        vapis="$vapis $vapi"
    done
    echo -e "vapis: $vapis\n">&3
    echo -e "cfiles: vapis | $cfiles\n">&3
    echo -e "objects: cfiles | $objects\n">&3
    echo -e "build: objects">&3
    echo -e '\t$(CC) $(LDFLAGS) -o $(BINARY) '$objects>&3
    echo -e ''>&3

    echo '
clean:
	rm -rf $(VALACDIR) $(OBSDIR)

spotless: clean
	rm -rf $(VALAHEADERDIR) $(VALAVAPIDIR)
'>&3

    echo '
genmake:
	./valagenmake.sh
'>&3
}

if [ -f genconfig ] ; then
    source ./genconfig
fi

rm -f Makefile
exec 3<> Makefile
generate_$MAKE_TYPE
# exec 3>&-
