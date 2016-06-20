CC = gcc
CFLAGS =
DEPS = fastboot.h usb.h
OBJ = protocol.o engine.o fastboot.o 
SRC = protocol.c engine.c fastboot.c 
TARGETS := fastboot

ifeq ($(OS),Windows_NT)
	SRC += usb_windows.c util_windows.c
	OBJ += usb_windows.o util_windows.o
else
	HOST_OS := $(shell uname -s)
	ifeq ($(HOST_OS),Darwin)
		CFLAGS += -framework CoreFoundation -framework IOKit -framework Carbon 
		SRC += usb_osx.c util_osx.c
		OBJ += usb_osx.o util_osx.o
	endif

	ifeq ($(HOST_OS),Linux)
		SRC += usb_linux.c util_linux.c
		OBJ += usb_linux.o util_linux.o
	endif
endif

%.o: %.c $(DEPS)
	$(CC) -c -o $@ $< $(CFLAGS)

make: $(OBJ)
	echo $OS
	$(CC) -Wall -lpthread $(CFLAGS) $(SRC) -o $(TARGETS)

clean:
	rm -f *.o
	rm -f $(TARGETS)