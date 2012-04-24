#include <mpi.h>

// Communication handles

MPI_Comm mpiwrap_get_mpi_comm_world() { return MPI_COMM_WORLD; }
MPI_Comm mpiwrap_get_mpi_comm_self()  { return MPI_COMM_SELF;  }

// Data types
MPI_Datatype mpiwrap_get_mpi_int()    { return MPI_INT;    }
MPI_Datatype mpiwrap_get_mpi_double() { return MPI_DOUBLE; }

// Operations
MPI_Op mpiwrap_get_mpi_max() { return MPI_MAX; }
MPI_Op mpiwrap_get_mpi_min() { return MPI_MIN; }
MPI_Op mpiwrap_get_mpi_sum() { return MPI_SUM; }
MPI_Op mpiwrap_get_mpi_prod() { return MPI_PROD; }
