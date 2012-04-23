// Some basic MPI routines

import std.algorithm, std.array, std.string;

alias void *MPI_Comm;

// MPI external functions
extern(C) {
  int MPI_Init(int *argc, char ***argv);

  int MPI_Comm_rank(MPI_Comm comm, int *rank);
  int MPI_Comm_size(MPI_Comm comm, int *size);
  
  int MPI_Finalize();
}

//////////////////////////////////////////////////////////////////////
// MPI wrapper functions to get predefined handles like MPI_COMM_WORLD
//
// Done this way as different MPI implementations use different means
// to define these quantities e.g. macros. This lacks something in elegance,
// but is more portable
extern(C) {
  MPI_Comm mpiwrap_get_mpi_comm_world();
  MPI_Comm mpiwrap_get_mpi_comm_self();
}

MPI_Comm MPI_COMM_WORLD, MPI_COMM_SELF, MPI_COMM_EMPTY;

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
}

int MPI_Comm_rank(MPI_Comm comm) {
  int rank;
  if(  MPI_Comm_rank(comm, &rank) ) {
    throw new Exception("");
  }
  return rank;
}

