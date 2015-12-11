

all: hid lc4500_main 
#BB-BONE-LC4500

HIDOBJS     = hidapi-master/linux/hid.o


hid: $(HIDOBJS)
	@cd hidapi-master/linux; make -f Makefile-manual-arm; cp hid.o ../../objs

lc4500_main: $(HIDOBJS)
	@cd objs; make; cp lc4500_main .. 

install: lc4500_main
	service lc4500-pem.sh stop; sleep 10; cp lc4500_main /usr/bin/. 

clean:
	rm lc4500_main; rm objs/lc4500_main

