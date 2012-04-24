// Some basic MPI routines

import std.algorithm, std.array, std.string;

// Type declarations. Internal structure not needed, only the address
alias void* MPI_Comm;
alias void* MPI_Datatype;
alias void* MPI_Op;

// MPI external functions
extern(C) {
  int MPI_Init(int *argc, char ***argv);

  int MPI_Comm_rank(MPI_Comm comm, int *rank);
  int MPI_Comm_size(MPI_Comm comm, int *size);
  
  int MPI_Finalize();

  int MPI_Bcast(void *buffer, int count, MPI_Datatype datatype, int root, MPI_Comm comm);
  
  int MPI_Reduce(void *sendbuf, void *recvbuf, int count, 
                 MPI_Datatype datatype, MPI_Op op, int root, MPI_Comm comm);
}

//////////////////////////////////////////////////////////////////////
// MPI wrapper functions to get predefined handles like MPI_COMM_WORLD
//
// Done this way as different MPI implementations use different means
// to define these quantities e.g. macros. This lacks something in elegance,
// but is more portable between MPI implementations

// Communicators
MPI_Comm MPI_COMM_WORLD, MPI_COMM_SELF;
extern(C) {
  MPI_Comm mpiwrap_get_mpi_comm_world();
  MPI_Comm mpiwrap_get_mpi_comm_self();
}

// Data types
MPI_Datatype MPI_INT, MPI_DOUBLE;
extern(C) {
  MPI_Datatype mpiwrap_get_mpi_int();
  MPI_Datatype mpiwrap_get_mpi_double();
}

// Operations
MPI_Op MPI_MAX, MPI_MIN, MPI_SUM, MPI_PROD;
extern(C) {
  MPI_Op mpiwrap_get_mpi_max();
  MPI_Op mpiwrap_get_mpi_min();
  MPI_Op mpiwrap_get_mpi_sum();
  MPI_Op mpiwrap_get_mpi_prod();
}

//////////////////////////////////////////////////////////////////////
// Wrapper functions to avoid use of pointers and convert
// error codes to exceptions

void MPI_Init(string[] args) {
  // Convert arguments to C form
  int argc = args.length;
  char** argv = cast(char**) array(map!toStringz(args)).ptr;

  // Call C function
  if( MPI_Init(&argc, &argv) ) {
    // Convert error code to an exception
    throw new Exception("Failed to initialise MPI");
  }
  
  MPI_COMM_WORLD = mpiwrap_get_mpi_comm_world();
  MPI_COMM_SELF  = mpiwrap_get_mpi_comm_self();
  
  MPI_INT = mpiwrap_get_mpi_int();
  MPI_DOUBLE = mpiwrap_get_mpi_double();
  
  MPI_MAX = mpiwrap_get_mpi_max();
  MPI_MIN = mpiwrap_get_mpi_min();
  MPI_SUM = mpiwrap_get_mpi_sum();
  MPI_PROD = mpiwrap_get_mpi_prod();
}

int MPI_Comm_rank(MPI_Comm comm) {
  int rank;
  if(  MPI_Comm_rank(comm, &rank) ) {
    throw new Exception("MPI_Comm_rank failed");
  }
  return rank;
}

int MPI_Comm_size(MPI_Comm comm) {
  int size;
  if(  MPI_Comm_size(comm, &size) ) {
    throw new Exception("MPI_Comm_size failed");
  }
  return size;
}

