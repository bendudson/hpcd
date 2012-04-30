/*
  IS - Abstract PETSc object that allows indexing.

 */
import petsc.c.types;
import petsc.c.error;
import petsc.c.sys;
import petsc.c.viewer;

// IS - Abstract PETSc object that allows indexing.
alias void* IS;

alias char* ISType;

alias void* ISLocalToGlobalMapping;


immutable IS_FILE_CLASSID = 1211218;

extern(C) {
  extern __gshared PetscClassId IS_CLASSID;
  
  extern PetscErrorCode ISInitializePackage(const char*);
}

// Dynamic creation and loading functions
extern(C) {
  extern __gshared PetscFList ISList;
  extern __gshared PetscBool  ISRegisterAllCalled;
  extern PetscErrorCode  ISSetType(IS, const ISType);
  extern PetscErrorCode  ISGetType(IS, const ISType *);
  extern PetscErrorCode  ISRegister(const char*,const char*,const char*,PetscErrorCode function(IS));
  extern PetscErrorCode  ISRegisterAll(const char *);
  extern PetscErrorCode  ISRegisterDestroy();
  extern PetscErrorCode  ISCreate(MPI_Comm,IS*);
}

/*
    Default index set data structures that PETSc provides.
*/
extern(C) {
  extern PetscErrorCode    ISCreateGeneral(MPI_Comm,PetscInt,const PetscInt*,PetscCopyMode,IS *);
  extern PetscErrorCode    ISGeneralSetIndices(IS,PetscInt,const PetscInt*,PetscCopyMode);
  extern PetscErrorCode    ISCreateBlock(MPI_Comm,PetscInt,PetscInt,const PetscInt*,PetscCopyMode,IS *);
  extern PetscErrorCode    ISBlockSetIndices(IS,PetscInt,PetscInt,const PetscInt*,PetscCopyMode);
  extern PetscErrorCode    ISCreateStride(MPI_Comm,PetscInt,PetscInt,PetscInt,IS *);
  extern PetscErrorCode    ISStrideSetStride(IS,PetscInt,PetscInt,PetscInt);

  extern PetscErrorCode    ISDestroy(IS*);
  extern PetscErrorCode    ISSetPermutation(IS);
  extern PetscErrorCode    ISPermutation(IS,PetscBool *); 
  extern PetscErrorCode    ISSetIdentity(IS);
  extern PetscErrorCode    ISIdentity(IS,PetscBool *);
  extern PetscErrorCode    ISContiguousLocal(IS,PetscInt,PetscInt,PetscInt*,PetscBool*);

  extern PetscErrorCode    ISGetIndices(IS,const PetscInt **);
  extern PetscErrorCode    ISRestoreIndices(IS,const PetscInt **);
  extern PetscErrorCode    ISGetTotalIndices(IS,const PetscInt **);
  extern PetscErrorCode    ISRestoreTotalIndices(IS,const PetscInt **);
  extern PetscErrorCode    ISGetNonlocalIndices(IS,const PetscInt **);
  extern PetscErrorCode    ISRestoreNonlocalIndices(IS,const PetscInt **);
  extern PetscErrorCode    ISGetNonlocalIS(IS, IS*);
  extern PetscErrorCode    ISRestoreNonlocalIS(IS, IS*);
  extern PetscErrorCode    ISGetSize(IS,PetscInt *);
  extern PetscErrorCode    ISGetLocalSize(IS,PetscInt *);
  extern PetscErrorCode    ISInvertPermutation(IS,PetscInt,IS*);
  extern PetscErrorCode    ISView(IS,PetscViewer);
  extern PetscErrorCode    ISEqual(IS,IS,PetscBool  *);
  extern PetscErrorCode    ISSort(IS);
  extern PetscErrorCode    ISSorted(IS,PetscBool  *);
  extern PetscErrorCode    ISDifference(IS,IS,IS*);
  extern PetscErrorCode    ISSum(IS,IS,IS*);
  extern PetscErrorCode    ISExpand(IS,IS,IS*);

  extern PetscErrorCode    ISBlockGetIndices(IS,const PetscInt **);
  extern PetscErrorCode    ISBlockRestoreIndices(IS,const PetscInt **);
  extern PetscErrorCode    ISBlockGetLocalSize(IS,PetscInt *);
  extern PetscErrorCode    ISBlockGetSize(IS,PetscInt *);
  extern PetscErrorCode    ISGetBlockSize(IS,PetscInt*);
  extern PetscErrorCode    ISSetBlockSize(IS,PetscInt);

  extern PetscErrorCode    ISStrideGetInfo(IS,PetscInt *,PetscInt*);

  extern PetscErrorCode    ISToGeneral(IS);

  extern PetscErrorCode    ISDuplicate(IS,IS*);
  extern PetscErrorCode    ISCopy(IS,IS);
  extern PetscErrorCode    ISAllGather(IS,IS*);
  extern PetscErrorCode    ISComplement(IS,PetscInt,PetscInt,IS*);
  extern PetscErrorCode    ISConcatenate(MPI_Comm,PetscInt,const IS*,IS*);
  extern PetscErrorCode    ISListToColoring(MPI_Comm,PetscInt, IS*,IS*,IS*);
  extern PetscErrorCode    ISColoringToList(IS, IS, PetscInt*, IS **);
  extern PetscErrorCode    ISOnComm(IS,MPI_Comm,PetscCopyMode,IS*);
}

