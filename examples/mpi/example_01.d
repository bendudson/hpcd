/*
 * A simple program to calculate PI 
 * 
 * Translated from
 * http://www.mcs.anl.gov/research/projects/mpi/usingmpi/examples/simplempi/cpi_c.htm
 *
 * Using low-level MPI routines, so very similar to the C version
 *
 */

import mpi.mpi;
import std.stdio;
import std.conv : parse;
import std.math : abs;

int main(string[] args) {

  immutable PI25DT = 3.141592653589793238462643; 
  
  MPI_Init(args);

  int myid = MPI_Comm_rank(MPI_COMM_WORLD);
  int numprocs = MPI_Comm_size(MPI_COMM_WORLD);
  
  while(true) {
    int n; // Number of intervals
    if(myid == 0) {
      try {
        writeln("Enter the number of intervals: (0 quits) ");
        char[] buf;
        stdin.readln(buf);  // Read a line into a buffer
        n = parse!int(buf); // Get an int from the buffer
      }catch(Exception e) {
        writeln("Invalid number entered");
        n = 0;
      }
    }
    MPI_Bcast(&n, 1, MPI_INT, 0, MPI_COMM_WORLD);
    
    if( n == 0 )
      break;
    
    double h   = 1.0 / n, sum = 0.0;
    for (int i = myid + 1; i <= n; i += numprocs) { 
      double x = h * (i - 0.5); 
      sum += (4.0 / (1.0 + x*x)); 
    }
    double mypi = h * sum, pi;
    MPI_Reduce(&mypi, &pi, 1, MPI_DOUBLE, MPI_SUM, 0, MPI_COMM_WORLD); 
    
    if (myid == 0)  
      writefln("pi is approximately %.16f, Error is %.16f\n", pi, abs(pi - PI25DT)); 
  }

  MPI_Finalize();
  return 0;
}

