CC:=gcc
COMP:=-fopenmp 
CFLAGS:=
LD:=gcc
LOMP:=-fopenmp
LFLAGS:= 

EXECUTABLE := omp-test

SOURCES = omp-test.c
OBJ_FILES = omp-test.o

$(EXECUTABLE) : $(SOURCES)
	$(CC) -c $(COMP) $(SOURCES) $(CFLAGS)
	$(LD) -o $(EXECUTABLE) $(LOMP) $(OBJ_FILES) $(LFLAGS)

clean :
	rm -rf $(OBJ_FILES) $(EXECUTABLE)
