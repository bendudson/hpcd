// Wrapper around petscsys.h

import std.algorithm, std.array, std.string;

alias int PetscErrorCode;

// Note: Can be either C++ or C 
extern(C++) {
  PetscErrorCode PetscInitialize(int*,char***,const char*,const char*);
  PetscErrorCode PetscFinalize();
}

// A wrapper to convert D's arguments to C style
// and handle ierr
void PetscInitialize(string[] args) {  
  int argc = args.length;
  char** argv = cast(char**) array(map!toStringz(args)).ptr;

  int ierr = PetscInitialize(&argc, &argv, null, null);
}

///////////////////////////////////////////////////////////////
// Simple parallel IO for ASCII printing
//
///////////////////////////////////////////////////////////////




