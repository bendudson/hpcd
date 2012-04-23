#include <mpi.h>

MPI_Comm mpiwrap_get_mpi_comm_world() {
  return MPI_COMM_WORLD;
}

MPI_Comm mpiwrap_get_mpi_comm_self() {
  return MPI_COMM_SELF;
}

