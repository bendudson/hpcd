// Defines some widely used data types

alias int PetscBool;
alias double PetscReal;
alias int PetscMPIInt;

alias int PetscClassId;

// PetscObject - any PETSc object, PetscViewer, Mat, Vec, KSP etc
// Internal structure (struct _p_PetscObject) not needed so use void pointer
alias void* PetscObject;

extern(C) {
  extern __gshared PetscClassId PETSC_VIEWER_CLASSID;
}
