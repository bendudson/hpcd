// Defines some widely used data types

alias int PetscBool;
alias int PetscInt;
alias int PetscMPIInt;
alias double PetscReal;
alias double PetscScalar;
alias int PetscEnum;
alias int PetscClassId;

alias void* PetscRandom;

immutable PETSC_NULL = null;

immutable PETSC_SMALL = 1e-10;

// PetscObject - any PETSc object, PetscViewer, Mat, Vec, KSP etc
// Internal structure (struct _p_PetscObject) not needed so use void pointer
alias void* PetscObject;

extern(C) {
  extern __gshared PetscClassId PETSC_VIEWER_CLASSID;
}

enum InsertMode {NOT_SET_VALUES, INSERT_VALUES, ADD_VALUES, MAX_VALUES, INSERT_ALL_VALUES, ADD_ALL_VALUES};

alias void* PetscFList;
