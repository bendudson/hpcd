// Defines some widely used data types

alias int PetscBool;
alias int PetscInt;
alias int PetscMPIInt;
alias double PetscReal;
alias double PetscScalar;

alias int PetscClassId;

// PetscObject - any PETSc object, PetscViewer, Mat, Vec, KSP etc
// Internal structure (struct _p_PetscObject) not needed so use void pointer
alias void* PetscObject;

extern(C) {
  extern __gshared PetscClassId PETSC_VIEWER_CLASSID;
}
