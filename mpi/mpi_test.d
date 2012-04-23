
import mpi;
import std.stdio;

int main(string[] args) {
  MPI_Init(args);

  int rank = MPI_Comm_rank(MPI_COMM_WORLD);

  writefln("Rank: %d\n", rank);

  MPI_Finalize();
  return 0;
}

