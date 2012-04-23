
SOURCED = mpi.d mpi_test.d
TARGET = mpi

OBJD = $(SOURCED:%.d=%.o)

CC = mpicc
DC = dmd
LIBS = -lphobos2

$(TARGET): $(OBJD) mpiwrap.o
	$(CC) -o $(TARGET) $(OBJD) mpiwrap.o  $(LIBS)

# Compile a thin wrapper around the MPI library
mpiwrap.o: mpiwrap.c
	$(CC) -o $@ -c $<

%.o: %.d
	$(DC) -c $<

