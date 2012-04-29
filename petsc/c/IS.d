/*
  IS - Abstract PETSc object that allows indexing.

 */
import petsc.c.types;

extern(C) {
  extern __gshared PetscClassId IS_CLASSID;
}

alias void* IS;
alias void* ISLocalToGlobalMapping;
