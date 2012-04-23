// Wrapper around petscsys.h

public import petsc.mpi 

import std.algorithm


typedef int PetscErrorCode;

extern(C) {
  PetscErrorCode PetscInitialize(int*,char***,const char[],const char[]);
}

// A wrapper to convert D's arguments to C style
// and handle ierr
void PetscInitialize(string[] args) {  
  int argc = args.length;
  const char** argv = array(map!toStringz(args)).ptr;

  int ierr = PetscInitialize(&argc, &argv, 0, 0);
}

///////////////////////////////////////////////////////////////
// Simple parallel IO for ASCII printing
//
///////////////////////////////////////////////////////////////

extern PetscErrorCode   PetscPrintf(MPI_Comm,const char[],...);


void PetscPrintf() {

}

PetscFinalize() {

}

