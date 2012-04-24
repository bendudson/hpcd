
SOURCED = mpi.d example_01.d
TARGET = mpi

OBJD = $(SOURCED:%.d=%.o)

include ../make.config

LIBS = -lphobos2 -lrt

$(TARGET): $(OBJD) mpiwrap.o
	$(CC) -o $(TARGET) $(OBJD) mpiwrap.o  $(LIBS)

# Compile a thin wrapper around the MPI library
mpiwrap.o: mpiwrap.c
	$(CC) -o $@ -c $<

%.o: %.d
	$(DC) -c $<

