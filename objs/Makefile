

all: lc4500_main 

APPOBJS     = 	lc4500_main.o 	\
                usb.o \
                hid.o \
		ads1255.o 		\
		dlpspectro.o 	\
		BMPParser.o 	\
		firmware.o 		\
		Display.o 		\
		Common.o 		\
		RTOS.o 			\
		TCPSocket.o 	\
		CmdHandler.o 	\
		API_IIC.o 		\
		API2.o 			\
		GPIO.o 			\
		Memory.o 		\
		cmdh.o 			\
		Pattern.o 		\
		PtnStream.o 	\
		Database.o 		\
		I2CRegister.o 	\
		DLPC350.o 		\
		drm_buff.o 		\
		Spectra4500.o 	\
		UpdateApp.o \
		LC4500IIC.o  



lc4500_main: $(APPOBJS) 
	$(CC) -ludev -lpthread -lm -ldrm $^ -o $@

