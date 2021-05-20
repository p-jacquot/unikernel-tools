CC:=gcc
CFLAGS:=
LD:=gcc
LFLAGS:= 

EXECUTABLE := hello

SOURCES = hello.c
OBJ_FILES = hello.o

$(EXECUTABLE) : $(SOURCES)
	$(CC) -c $(SOURCES) $(CFLAGS)
	$(LD) -o $(EXECUTABLE) $(OBJ_FILES) $(LFLAGS)

clean :
	rm -rf $(OBJ_FILES) $(EXECUTABLE)
