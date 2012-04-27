// Error handling interfaces for PETSc

import mpi.mpi;

alias int PetscErrorCode;

enum PetscErrorType {initial = 0, repeat = 1, in_cxx = 2};

extern(C) {
  PetscErrorCode  PetscErrorPrintfInitialize();
  PetscErrorCode  PetscErrorMessage(int,const char**,char **);
  PetscErrorCode  PetscError(MPI_Comm,int,const char*,const char*,const char*,PetscErrorCode,int,const char*,...);
}

alias MPI_COMM_SELF PETSC_COMM_SELF;

void CHKERRQ(PetscErrorCode n, string file = __FILE__, size_t line = __LINE__) {
  if(n) {
    PetscError(PETSC_COMM_SELF, cast(int) line, 
               "User function",  // PETSC_FUNCTION_NAME
               file.ptr, 
               "-",  // __SDIR__
               n,
               cast(int) PetscErrorType.repeat,
               " "); 
    throw new Exception("error message here", file, line);
  }
}

