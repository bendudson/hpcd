/* 
    Defines the vector component of PETSc. Vectors generally represent 
  degrees of freedom for finite element/finite difference functions
  on a grid. They have more mathematical structure then simple arrays.
*/

import petsc.c.types;
import petsc.c.sys;
import petsc.c.IS;

// Vec - Abstract PETSc vector object
// Internal structure of Vec not needed, so can just be a void pointer
alias void* Vec;

// VecScatter - Object used to manage communication of data
//    between vectors in parallel. Manages both scatters and gathers
alias void* VecScatter;

/* 
   ScatterMode - Determines the direction of a scatter

   FORWARD - Scatters the values as dictated by the VecScatterCreate() call
   REVERSE - Moves the values in the opposite direction then the directions indicated in
             the VecScatterCreate()
   FORWARD_LOCAL - Scatters the values as dictated by the VecScatterCreate() call
                   except NO parallel communication is done. Any variables that have
                   be moved between processes are ignored
   REVERSE_LOCAL - Moves the values in the opposite direction then the directions indicated in
                   in the VecScatterCreate()  except NO parallel communication
                   is done. Any variables that have be moved between processes are ignored
   
 */
enum ScatterMode {FORWARD=0, REVERSE=1, FORWARD_LOCAL=2, REVERSE_LOCAL=3, LOCAL=2};

// Logging support
extern(C) {
  extern __gshared PetscClassId VEC_CLASSID;
  extern __gshared PetscClassId VEC_SCATTER_CLASSID;
}

extern(C) {
  PetscErrorCode  VecInitializePackage(const char*);
  PetscErrorCode  VecFinalizePackage();

  PetscErrorCode  VecCreate(MPI_Comm,Vec*);
  PetscErrorCode  VecCreateSeq(MPI_Comm,PetscInt,Vec*);
  PetscErrorCode  VecCreateMPI(MPI_Comm,PetscInt,PetscInt,Vec*);
  PetscErrorCode  VecCreateSeqWithArray(MPI_Comm,PetscInt,const PetscScalar*,Vec*);
  PetscErrorCode  VecCreateMPIWithArray(MPI_Comm,PetscInt,PetscInt,const PetscScalar*,Vec*);
  PetscErrorCode  VecCreateShared(MPI_Comm,PetscInt,PetscInt,Vec*);
  PetscErrorCode  VecSetFromOptions(Vec);
  PetscErrorCode  VecSetUp(Vec);
  PetscErrorCode  VecDestroy(Vec*);
  PetscErrorCode  VecZeroEntries(Vec);
  PetscErrorCode  VecSetOptionsPrefix(Vec,const char*);
  PetscErrorCode  VecAppendOptionsPrefix(Vec,const char*);
  PetscErrorCode  VecGetOptionsPrefix(Vec,const char**);

  PetscErrorCode  VecSetSizes(Vec,PetscInt,PetscInt);
  
  PetscErrorCode  VecDotNorm2(Vec,Vec,PetscScalar*,PetscScalar*);
  PetscErrorCode  VecDot(Vec,Vec,PetscScalar*);
  PetscErrorCode  VecTDot(Vec,Vec,PetscScalar*);
  PetscErrorCode  VecMDot(Vec,PetscInt,const Vec*,PetscScalar*);
  PetscErrorCode  VecMTDot(Vec,PetscInt,const Vec*,PetscScalar*);
  PetscErrorCode  VecGetSubVector(Vec,IS,Vec*);
  PetscErrorCode  VecRestoreSubVector(Vec,IS,Vec*);
}

// Define the PetscPolymorphicSubroutine versions

PetscErrorCode VecCreate(Vec* x) {
  return VecCreate(PETSC_COMM_SELF, x);
}

PetscErrorCode  VecCreateSeq(PetscInt n,Vec *x) {
  return VecCreateSeq(PETSC_COMM_SELF,n,x);
}

PetscErrorCode  VecCreateMPI(PetscInt n,PetscInt N,Vec *x) {
  return VecCreateMPI(PETSC_COMM_WORLD,n,N,x);
}

PetscErrorCode  VecCreateSeqWithArray(PetscInt n,PetscScalar* s,Vec *x) {
  return VecCreateSeqWithArray(PETSC_COMM_SELF,n,s,x);
}

PetscErrorCode  VecCreateMPIWithArray(PetscInt n,PetscInt N,PetscScalar* s,Vec *x) {
  return VecCreateMPIWithArray(PETSC_COMM_WORLD,n,N,s,x);
}

PetscScalar VecDot(Vec x,Vec y) {
  PetscScalar s;
  VecDot(x,y,&s);
  return s;
}

PetscScalar  VecTDot(Vec x,Vec y) {
  PetscScalar s;
  VecTDot(x,y,&s);
  return s;
}

