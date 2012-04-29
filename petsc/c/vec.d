/* 
    Defines the vector component of PETSc. Vectors generally represent 
  degrees of freedom for finite element/finite difference functions
  on a grid. They have more mathematical structure then simple arrays.
*/

import petsc.c.types;
import petsc.c.sys;
import petsc.c.IS;
import petsc.c.viewer;

// Vec - Abstract PETSc vector object
// Internal structure of Vec not needed, so can just be a void pointer

struct Vec_t {};
alias Vec_t* Vec;
alias char* VecType;

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

PetscErrorCode  VecMDot(Vec v1,PetscInt i,const Vec* v2,PetscScalar[] s) {
  return VecMDot(v1, i, v2, s.ptr);
}

PetscErrorCode  VecMTDot(Vec v1,PetscInt i,const Vec* v2,PetscScalar[] s) {
  return VecMTDot(v1, i, v2, s.ptr);
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

enum NormType {NORM_1=0, NORM_2=1, NORM_FROBENIUS=2, NORM_INFINITY=3, NORM_1_AND_2=4};

extern(C) {
  extern __gshared char** NormTypes;
}

extern(C) {
  PetscErrorCode  VecNorm(Vec,NormType,PetscReal *);
  PetscErrorCode  VecNormAvailable(Vec,NormType,PetscBool *,PetscReal *);
  PetscErrorCode  VecNormalize(Vec,PetscReal *);
  PetscErrorCode  VecSum(Vec,PetscScalar*);
  PetscErrorCode  VecMax(Vec,PetscInt*,PetscReal *);
  PetscErrorCode  VecMin(Vec,PetscInt*,PetscReal *);
  PetscErrorCode  VecScale(Vec,PetscScalar);
  PetscErrorCode  VecCopy(Vec,Vec);
  PetscErrorCode  VecSetRandom(Vec,PetscRandom);
  PetscErrorCode  VecSet(Vec,PetscScalar);
  PetscErrorCode  VecSwap(Vec,Vec);
  PetscErrorCode  VecAXPY(Vec,PetscScalar,Vec);  
  PetscErrorCode  VecAXPBY(Vec,PetscScalar,PetscScalar,Vec);  
  PetscErrorCode  VecMAXPY(Vec,PetscInt,const PetscScalar*,Vec*);
  PetscErrorCode  VecAYPX(Vec,PetscScalar,Vec);
  PetscErrorCode  VecWAXPY(Vec,PetscScalar,Vec,Vec);
  PetscErrorCode  VecAXPBYPCZ(Vec,PetscScalar,PetscScalar,PetscScalar,Vec,Vec);
  PetscErrorCode  VecPointwiseMax(Vec,Vec,Vec);
  PetscErrorCode  VecPointwiseMaxAbs(Vec,Vec,Vec);
  PetscErrorCode  VecPointwiseMin(Vec,Vec,Vec);
  PetscErrorCode  VecPointwiseMult(Vec,Vec,Vec);
  PetscErrorCode  VecPointwiseDivide(Vec,Vec,Vec);
  PetscErrorCode  VecMaxPointwiseDivide(Vec,Vec,PetscReal*);    
  PetscErrorCode  VecShift(Vec,PetscScalar);
  PetscErrorCode  VecReciprocal(Vec);
  PetscErrorCode  VecPermute(Vec, IS, PetscBool );
  PetscErrorCode  VecSqrtAbs(Vec);
  PetscErrorCode  VecLog(Vec);
  PetscErrorCode  VecExp(Vec);
  PetscErrorCode  VecAbs(Vec);
  PetscErrorCode  VecDuplicate(Vec,Vec*);          
  PetscErrorCode  VecDuplicateVecs(Vec,PetscInt,Vec**);         
  PetscErrorCode  VecDestroyVecs(PetscInt, Vec**); 
  PetscErrorCode  VecStrideNormAll(Vec,NormType,PetscReal*);
  PetscErrorCode  VecStrideMaxAll(Vec,PetscInt *,PetscReal *);
  PetscErrorCode  VecStrideMinAll(Vec,PetscInt *,PetscReal *);
  PetscErrorCode  VecStrideScaleAll(Vec,const PetscScalar*);
}

PetscErrorCode  VecNorm(Vec x,PetscReal *r) {
  return VecNorm(x,NormType.NORM_2,r);
}

PetscReal VecNorm(Vec x,NormType t) {
  PetscReal r;
  VecNorm(x,t,&r);
  return r;
}

PetscReal VecNorm(Vec x) {
  return VecNorm(x, NormType.NORM_2);
}

PetscErrorCode  VecMax(Vec x,PetscReal *r) {
  return VecMax(x,null,r);
}

PetscErrorCode  VecMAXPY(Vec v1,PetscInt i,const PetscScalar[] s,Vec* v2) {
  return VecMAXPY(v1,i,s.ptr,v2);
}

PetscErrorCode  VecMin(Vec x,PetscReal *r) {
  return VecMin(x,null,r);
}

PetscErrorCode  VecPointwiseMax(Vec x,Vec y) {
  return VecPointwiseMax(x,y,y);
}

PetscErrorCode  VecPointwiseMaxAbs(Vec x,Vec y) {
  return VecPointwiseMaxAbs(x,y,y);
}

PetscErrorCode  VecPointwiseMin(Vec x,Vec y) {
  return VecPointwiseMin(x,y,y);
}

PetscErrorCode  VecPointwiseMult(Vec x,Vec y) {
  return VecPointwiseMult(x,y,y);
}

PetscErrorCode  VecPointwiseDivide(Vec x,Vec y) {
  return VecPointwiseDivide(x,y,y);
}

extern(C) {
  PetscErrorCode  VecStrideNorm(Vec,PetscInt,NormType,PetscReal*);
  PetscErrorCode  VecStrideMax(Vec,PetscInt,PetscInt *,PetscReal *);
  PetscErrorCode  VecStrideMin(Vec,PetscInt,PetscInt *,PetscReal *);
  PetscErrorCode  VecStrideScale(Vec,PetscInt,PetscScalar);
  PetscErrorCode  VecStrideSet(Vec,PetscInt,PetscScalar);
}

PetscReal VecStrideNorm(Vec x,PetscInt i, NormType t = NormType.NORM_2) {
  PetscReal r;
  VecStrideNorm(x,i,t,&r);
  return r;
}

PetscReal VecStrideMax(Vec x,PetscInt i) {
  PetscReal r;
  VecStrideMax(x,i,null,&r);
  return r;
}

PetscReal VecStrideMin(Vec x,PetscInt i) {
  PetscReal r;
  VecStrideMin(x,i,null,&r);
  return r;
}

extern(C) {
  PetscErrorCode  VecStrideGather(Vec,PetscInt,Vec,InsertMode);
  PetscErrorCode  VecStrideScatter(Vec,PetscInt,Vec,InsertMode);
  PetscErrorCode  VecStrideGatherAll(Vec,Vec*,InsertMode);
  PetscErrorCode  VecStrideScatterAll(Vec*,Vec,InsertMode);

  PetscErrorCode  VecSetValues(Vec,PetscInt,const PetscInt*,const PetscScalar*,InsertMode);
  PetscErrorCode  VecGetValues(Vec,PetscInt,const PetscInt*,PetscScalar*);
  PetscErrorCode  VecAssemblyBegin(Vec);
  PetscErrorCode  VecAssemblyEnd(Vec);
  PetscErrorCode  VecStashSetInitialSize(Vec,PetscInt,PetscInt);
  PetscErrorCode  VecStashView(Vec,PetscViewer);
  PetscErrorCode  VecStashGetInfo(Vec,PetscInt*,PetscInt*,PetscInt*,PetscInt*);
}

PetscErrorCode VecSetValue(Vec v,PetscInt i,PetscScalar va,InsertMode mode) {return VecSetValues(v,1,&i,&va,mode);}

extern(C) {
  PetscErrorCode  VecSetBlockSize(Vec,PetscInt);
  PetscErrorCode  VecGetBlockSize(Vec,PetscInt*);
  PetscErrorCode  VecSetValuesBlocked(Vec,PetscInt,const PetscInt*,const PetscScalar*,InsertMode);
}

PetscInt VecGetBlockSize(Vec x) {
  PetscInt i;
  VecGetBlockSize(x,&i);
  return i;
}

/* Dynamic creation and loading functions */
extern(C) {
  extern __gshared PetscFList VecList;
  extern __gshared PetscBool VecRegisterAllCalled;

  PetscErrorCode  VecSetType(Vec, const VecType);
  PetscErrorCode  VecGetType(Vec, const VecType *);
  PetscErrorCode  VecRegister(const char*,const char*,const char*,PetscErrorCode function(Vec));
  PetscErrorCode  VecRegisterAll(const char *);
  PetscErrorCode  VecRegisterDestroy();

  PetscErrorCode  VecScatterCreate(Vec,IS,Vec,IS,VecScatter *);
  PetscErrorCode  VecScatterCreateEmpty(MPI_Comm,VecScatter *);
  PetscErrorCode  VecScatterCreateLocal(VecScatter,PetscInt,const PetscInt*,const PetscInt*,const PetscInt*,PetscInt,const PetscInt*,const PetscInt*,const PetscInt*,PetscInt);
  PetscErrorCode  VecScatterBegin(VecScatter,Vec,Vec,InsertMode,ScatterMode);
  PetscErrorCode  VecScatterEnd(VecScatter,Vec,Vec,InsertMode,ScatterMode); 
  PetscErrorCode  VecScatterDestroy(VecScatter*);
  PetscErrorCode  VecScatterCopy(VecScatter,VecScatter *);
  PetscErrorCode  VecScatterView(VecScatter,PetscViewer);
  PetscErrorCode  VecScatterRemap(VecScatter,PetscInt *,PetscInt*);
  PetscErrorCode  VecScatterGetMerged(VecScatter,PetscBool *);
}

VecScatter VecScatterCreate(Vec x,IS is1,Vec y,IS is2 = PETSC_NULL) {
  VecScatter s;
  VecScatterCreate(x,is1,y,is2,&s);
  return s;
}

VecScatter VecScatterCreate(Vec x,Vec y,IS is2) {
  VecScatter s;
  VecScatterCreate(x,PETSC_NULL,y,is2,&s);
  return s;
}

PetscErrorCode  VecScatterCreate(Vec x,IS i,Vec y,VecScatter *s) {
  return VecScatterCreate(x,i,y,PETSC_NULL,s);
}
PetscErrorCode  VecScatterCreate(Vec x,Vec y,IS i,VecScatter *s) {
  return VecScatterCreate(x,PETSC_NULL,y,i,s);
}

extern(C) {
  PetscErrorCode  VecGetArray4d(Vec,PetscInt,PetscInt,PetscInt,PetscInt,PetscInt,PetscInt,PetscInt,PetscInt,PetscScalar*****);
  PetscErrorCode  VecRestoreArray4d(Vec,PetscInt,PetscInt,PetscInt,PetscInt,PetscInt,PetscInt,PetscInt,PetscInt,PetscScalar*****);
  PetscErrorCode  VecGetArray3d(Vec,PetscInt,PetscInt,PetscInt,PetscInt,PetscInt,PetscInt,PetscScalar****);
  PetscErrorCode  VecRestoreArray3d(Vec,PetscInt,PetscInt,PetscInt,PetscInt,PetscInt,PetscInt,PetscScalar****);
  PetscErrorCode  VecGetArray2d(Vec,PetscInt,PetscInt,PetscInt,PetscInt,PetscScalar***);
  PetscErrorCode  VecRestoreArray2d(Vec,PetscInt,PetscInt,PetscInt,PetscInt,PetscScalar***);
  PetscErrorCode  VecGetArray1d(Vec,PetscInt,PetscInt,PetscScalar **);
  PetscErrorCode  VecRestoreArray1d(Vec,PetscInt,PetscInt,PetscScalar **);

  PetscErrorCode  VecPlaceArray(Vec,const PetscScalar*);
  PetscErrorCode  VecResetArray(Vec);
  PetscErrorCode  VecReplaceArray(Vec,const PetscScalar*);
  PetscErrorCode  VecGetArrays(const Vec*,PetscInt,PetscScalar***);
  PetscErrorCode  VecRestoreArrays(const Vec*,PetscInt,PetscScalar***);

  PetscErrorCode  VecView(Vec,PetscViewer);
  PetscErrorCode  VecViewFromOptions(Vec, const char *);
  PetscErrorCode  VecEqual(Vec,Vec,PetscBool *);
  PetscErrorCode  VecLoad(Vec, PetscViewer);
}

PetscBool VecEqual(Vec x,Vec y) {
  PetscBool s;
  VecEqual(x,y,&s);
  return s;
}

extern(C) {
  PetscErrorCode  VecGetSize(Vec,PetscInt*);
  PetscErrorCode  VecGetLocalSize(Vec,PetscInt*);
  PetscErrorCode  VecGetOwnershipRange(Vec,PetscInt*,PetscInt*);
  PetscErrorCode  VecGetOwnershipRanges(Vec,const PetscInt **);

  PetscErrorCode  VecSetLocalToGlobalMapping(Vec,ISLocalToGlobalMapping);
  PetscErrorCode  VecSetValuesLocal(Vec,PetscInt,const PetscInt*,const PetscScalar*,InsertMode);
}

PetscInt VecGetSize(Vec x) {
  PetscInt s;
  VecGetSize(x,&s);
  return s;
}

PetscInt VecGetLocalSize(Vec x) {
  PetscInt s;
  VecGetLocalSize(x,&s);
  return s;
}

PetscErrorCode VecSetValueLocal(Vec v,PetscInt i,PetscScalar va,InsertMode mode) {return VecSetValuesLocal(v,1,&i,&va,mode);}

extern(C) {
  PetscErrorCode  VecSetLocalToGlobalMappingBlock(Vec,ISLocalToGlobalMapping);
  PetscErrorCode  VecSetValuesBlockedLocal(Vec,PetscInt,const PetscInt*,const PetscScalar*,InsertMode);
  PetscErrorCode  VecGetLocalToGlobalMappingBlock(Vec,ISLocalToGlobalMapping*);
  PetscErrorCode  VecGetLocalToGlobalMapping(Vec,ISLocalToGlobalMapping*);

  PetscErrorCode  VecDotBegin(Vec,Vec,PetscScalar *);
  PetscErrorCode  VecDotEnd(Vec,Vec,PetscScalar *);
  PetscErrorCode  VecTDotBegin(Vec,Vec,PetscScalar *);
  PetscErrorCode  VecTDotEnd(Vec,Vec,PetscScalar *);
  PetscErrorCode  VecNormBegin(Vec,NormType,PetscReal *);
  PetscErrorCode  VecNormEnd(Vec,NormType,PetscReal *);

  PetscErrorCode  VecMDotBegin(Vec,PetscInt,const Vec*,PetscScalar*);
  PetscErrorCode  VecMDotEnd(Vec,PetscInt,const Vec*,PetscScalar*);
  PetscErrorCode  VecMTDotBegin(Vec,PetscInt,const Vec*,PetscScalar*);
  PetscErrorCode  VecMTDotEnd(Vec,PetscInt,const Vec*,PetscScalar*);
}

PetscErrorCode  VecDotBegin(Vec x,Vec y) { return VecDotBegin(x,y,PETSC_NULL); }

PetscScalar VecDotEnd(Vec x,Vec y) {
  PetscScalar s;
  VecDotEnd(x,y,&s);
  return s;
}

PetscErrorCode  VecTDotBegin(Vec x,Vec y) { return VecTDotBegin(x,y,PETSC_NULL); }

PetscScalar VecTDotEnd(Vec x,Vec y) {
  PetscScalar s;
  VecTDotEnd(x,y,&s);
  return s;
}

PetscErrorCode  VecNormBegin(Vec x,NormType t = NormType.NORM_2) { return VecNormBegin(x,t,PETSC_NULL); }

PetscReal VecNormEnd(Vec x,NormType t = NormType.NORM_2) {
  PetscReal s;
  VecNormEnd(x,t,&s);
  return s;
}

enum VecOption {IGNORE_OFF_PROC_ENTRIES,IGNORE_NEGATIVE_INDICES};

extern(C) {
  PetscErrorCode  VecSetOption(Vec,VecOption,PetscBool );
  PetscErrorCode  VecContourScale(Vec,PetscReal,PetscReal);
}

enum VecOperation { VECOP_VIEW = 33, VECOP_LOAD = 41, VECOP_DUPLICATE = 0};

extern(C) {
  PetscErrorCode  VecSetOperation(Vec,VecOperation,void function());
}

/*
     Routines for dealing with ghosted vectors:
  vectors with ghost elements at the end of the array.
*/

extern(C) {
  PetscErrorCode  VecCreateGhost(MPI_Comm,PetscInt,PetscInt,PetscInt,const PetscInt*,Vec*);  
  PetscErrorCode  VecCreateGhostWithArray(MPI_Comm,PetscInt,PetscInt,PetscInt,const PetscInt*,const PetscScalar*,Vec*);  
  PetscErrorCode  VecCreateGhostBlock(MPI_Comm,PetscInt,PetscInt,PetscInt,PetscInt,const PetscInt*,Vec*);  
  PetscErrorCode  VecCreateGhostBlockWithArray(MPI_Comm,PetscInt,PetscInt,PetscInt,PetscInt,const PetscInt*,const PetscScalar*,Vec*);  
  PetscErrorCode  VecGhostGetLocalForm(Vec,Vec*);
  PetscErrorCode  VecGhostRestoreLocalForm(Vec,Vec*);
  PetscErrorCode  VecGhostUpdateBegin(Vec,InsertMode,ScatterMode);
  PetscErrorCode  VecGhostUpdateEnd(Vec,InsertMode,ScatterMode);
  
  PetscErrorCode  VecConjugate(Vec);
  
  PetscErrorCode  VecScatterCreateToAll(Vec,VecScatter*,Vec*);
  PetscErrorCode  VecScatterCreateToZero(Vec,VecScatter*,Vec*);

  PetscErrorCode  PetscViewerMathematicaGetVector(PetscViewer, Vec);
  PetscErrorCode  PetscViewerMathematicaPutVector(PetscViewer, Vec);
}

Vec VecGhostGetLocalForm(Vec x) {
  Vec s;
  VecGhostGetLocalForm(x,&s);
  return s;
}

/*
  Vecs - Collection of vectors where the data for the vectors is stored in 
         one contiguous memory
 */

struct _n_Vecs  {PetscInt n; Vec v;};
alias _n_Vecs* Vecs;


