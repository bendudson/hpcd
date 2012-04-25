/*
 * Example showing use of MPI_Send and MPI_Recv
 * 
 * NOTE: This is not a very good example, and will fail for > 10 processors
 * because the length of the message will be inconsistent.
 * 
 * Example translated from C
 * http://hamilton.nuigalway.ie/teaching/AOS/NINE/mpi-first-examples.html
 * 
 */

import mpi;
import std.stdio;
import std.string;

int main(string[] args) {
  MPI_Init(args);
  int my_rank = MPI_Comm_rank(MPI_COMM_WORLD);
  int size   = MPI_Comm_size(MPI_COMM_WORLD);
  
  string greeting = format("Hello world: processor %d of %d\n", my_rank, size);
  
  if (my_rank == 0) {
    writeln(greeting);
    for (int partner = 1; partner < size; partner++){
      
      MPI_Status stat;
      MPI_Recv(cast(void*)greeting.ptr, greeting.length, MPI_BYTE, partner, 1, MPI_COMM_WORLD, &stat);
      writeln(greeting);
    }
  }
  else {
    MPI_Send(cast(void*)greeting.ptr, greeting.length, MPI_BYTE, 0,1, MPI_COMM_WORLD);
  }
  
  if (my_rank == 0) writeln("That is all for now!\n");
  MPI_Finalize();
  
  return 0;
}