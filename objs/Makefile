#BB Local make file for OBJ files pulled from github

all: lc4500_main 

APPOBJS     = 	lc4500_main.o 	\
		hid.o		\
		usb.o 		\
		ads1255.o 	\
		dlpspectro.o 	\
		BMPParser.o 	\
		firmware.o 	\
		Display.o 	\
		Common.o 	\
		RTOS.o 		\
		TCPSocket.o 	\
		CmdHandler.o 	\
		API2.o 		\
		GPIO.o 		\
		Memory.o 	\
		cmdh.o 		\
		Pattern.o 	\
		PtnStream.o 	\
		Database.o 	\
		i2c.o 		\
		dlpc350_api.o 	\
		drm_buff.o 	\
		Spectra4500.o 	\
		UpdateApp.o     \
		i2c_platform.o



lc4500_main: $(APPOBJS) 
	$(CC) -ludev -lpthread -lm -ldrm $^ -o $@

