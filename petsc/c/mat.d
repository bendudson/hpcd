
import petsc.c.types;
import petsc.c.error;
import petsc.c.sys;
import petsc.c.IS;
import petsc.c.vec;

struct Mat_t {}
alias Mat_t* Mat;

/*
  MatType - String with the name of a PETSc matrix or the creation function
       with an optional dynamic library name, for example
       http://www.mcs.anl.gov/petsc/lib.a:mymatcreate()
 */
alias char* MatType;

// MatSolverPackage - String with the name of a PETSc matrix solver type
alias char* MatSolverPackage;

// MatFactorType - indicates what type of factorization is requested
enum MatFactorType {NONE, LU, CHOLESKY, ILU, ICC, ILUDT};

extern(C) {
  extern __gshared const char** MatFactorTypes;
  
  PetscErrorCode  MatGetFactor(Mat,const MatSolverPackage,MatFactorType,Mat*);
  PetscErrorCode  MatGetFactorAvailable(Mat,const MatSolverPackage,MatFactorType,PetscBool *);
  PetscErrorCode  MatFactorGetSolverPackage(Mat,const MatSolverPackage*);
  PetscErrorCode  MatGetFactorType(Mat,MatFactorType*);
}

immutable MAT_FILE_CLASSID = 1211216;

extern(C) {
  extern __gshared PetscClassId  MAT_CLASSID;
  extern __gshared PetscClassId  MAT_FDCOLORING_CLASSID;
  extern __gshared PetscClassId  MAT_PARTITIONING_CLASSID;
  extern __gshared PetscClassId  MAT_NULLSPACE_CLASSID;
  extern __gshared PetscClassId  MATMFFD_CLASSID;
}

/*
  MatReuse - Indicates if matrices obtained from a previous call to MatGetSubMatrices()
     or MatGetSubMatrix() are to be reused to store the new matrix values. For MatConvert() is used to indicate
     that the input matrix is to be replaced with the converted matrix.
 */
enum MatReuse {INITIAL,REUSE,IGNORE};

/*
  MatGetSubMatrixOption - Indicates if matrices obtained from a call to MatGetSubMatrices()
  include the matrix values. Currently it is only used by MatGetSeqNonzerostructure().
 */
enum MatGetSubMatrixOption {DO_NOT_GET_VALUES,GET_VALUES};

extern(C) {
  PetscErrorCode  MatInitializePackage(const char*);

  PetscErrorCode  MatCreate(MPI_Comm,Mat*);
  PetscErrorCode  MatSetSizes(Mat,PetscInt,PetscInt,PetscInt,PetscInt);
  PetscErrorCode  MatSetType(Mat,const MatType);
  PetscErrorCode  MatSetFromOptions(Mat);
  PetscErrorCode  MatSetUpPreallocation(Mat);
  PetscErrorCode  MatRegisterAll(const char*);
  PetscErrorCode  MatRegister(const char*,const char*,const char*,PetscErrorCode function(Mat));
  PetscErrorCode  MatRegisterBaseName(const char*,const char*,const char*);
  PetscErrorCode  MatSetOptionsPrefix(Mat,const char*);
  PetscErrorCode  MatAppendOptionsPrefix(Mat,const char*);
  PetscErrorCode  MatGetOptionsPrefix(Mat,const char**);
}

Mat MatCreate(MPI_Comm comm = PETSC_COMM_WORLD) {
  Mat A;
  MatCreate(comm,&A);
  return A;
}

// MatRegisterDynamic - Adds a new matrix type

extern(C) {
  extern __gshared PetscBool  MatRegisterAllCalled;
  extern __gshared PetscFList MatList;
  extern __gshared PetscFList MatColoringList;
  extern __gshared PetscFList MatPartitioningList;
}

// MatStructure - Indicates if the matrix has the same nonzero structure
enum MatStructure {DIFFERENT_NONZERO_PATTERN,SUBSET_NONZERO_PATTERN,SAME_NONZERO_PATTERN,SAME_PRECONDITIONER};

enum MatCompositeType {MAT_COMPOSITE_ADDITIVE,MAT_COMPOSITE_MULTIPLICATIVE};

extern(C) {
  PetscErrorCode MatCreateSeqDense(MPI_Comm,PetscInt,PetscInt,PetscScalar*,Mat*);
  PetscErrorCode MatCreateMPIDense(MPI_Comm,PetscInt,PetscInt,PetscInt,PetscInt,PetscScalar*,Mat*);
  PetscErrorCode MatCreateSeqAIJ(MPI_Comm,PetscInt,PetscInt,PetscInt,const PetscInt*,Mat*);
  PetscErrorCode MatCreateMPIAIJ(MPI_Comm,PetscInt,PetscInt,PetscInt,PetscInt,PetscInt,const PetscInt*,PetscInt,const PetscInt*,Mat*);
  PetscErrorCode MatCreateMPIAIJWithArrays(MPI_Comm,PetscInt,PetscInt,PetscInt,PetscInt,const PetscInt*,const PetscInt*,const PetscScalar*,Mat *);
  PetscErrorCode MatCreateMPIAIJWithSplitArrays(MPI_Comm,PetscInt,PetscInt,PetscInt,PetscInt,PetscInt*,PetscInt*,PetscScalar*,PetscInt*,PetscInt*,PetscScalar*,Mat*);

  PetscErrorCode MatCreateSeqBAIJ(MPI_Comm,PetscInt,PetscInt,PetscInt,PetscInt,const PetscInt*,Mat*);
  PetscErrorCode MatCreateMPIBAIJ(MPI_Comm,PetscInt,PetscInt,PetscInt,PetscInt,PetscInt,PetscInt,const PetscInt*,PetscInt,const PetscInt*,Mat*);
  PetscErrorCode MatCreateMPIBAIJWithArrays(MPI_Comm,PetscInt,PetscInt,PetscInt,PetscInt,PetscInt,const PetscInt*,const PetscInt*,const PetscScalar*,Mat*);

  PetscErrorCode MatCreateMPIAdj(MPI_Comm,PetscInt,PetscInt,PetscInt*,PetscInt*,PetscInt*,Mat*);
  PetscErrorCode MatCreateSeqSBAIJ(MPI_Comm,PetscInt,PetscInt,PetscInt,PetscInt,const PetscInt*,Mat*);

  PetscErrorCode MatCreateMPISBAIJ(MPI_Comm,PetscInt,PetscInt,PetscInt,PetscInt,PetscInt,PetscInt,const PetscInt*,PetscInt,const PetscInt*,Mat*);
  PetscErrorCode MatCreateMPISBAIJWithArrays(MPI_Comm,PetscInt,PetscInt,PetscInt,PetscInt,PetscInt,const PetscInt*,const PetscInt*,const PetscScalar*,Mat *);
  PetscErrorCode MatMPISBAIJSetPreallocationCSR(Mat,PetscInt,const PetscInt*,const PetscInt*,const PetscScalar*);

  PetscErrorCode MatCreateShell(MPI_Comm,PetscInt,PetscInt,PetscInt,PetscInt,void *,Mat*);
  PetscErrorCode MatCreateAdic(MPI_Comm,PetscInt,PetscInt,PetscInt,PetscInt,PetscInt,void function(),Mat*);
  PetscErrorCode MatCreateNormal(Mat,Mat*);
  PetscErrorCode MatCreateLRC(Mat,Mat,Mat,Mat*);
  PetscErrorCode MatCreateIS(MPI_Comm,PetscInt,PetscInt,PetscInt,PetscInt,ISLocalToGlobalMapping,Mat*);
  PetscErrorCode MatCreateSeqAIJCRL(MPI_Comm,PetscInt,PetscInt,PetscInt,const PetscInt*,Mat*);
  PetscErrorCode MatCreateMPIAIJCRL(MPI_Comm,PetscInt,PetscInt,PetscInt,const PetscInt*,PetscInt,const PetscInt*,Mat*);

  PetscErrorCode MatCreateSeqBSTRM(MPI_Comm,PetscInt,PetscInt,PetscInt,PetscInt,const PetscInt*,Mat*);
  PetscErrorCode MatCreateMPIBSTRM(MPI_Comm,PetscInt,PetscInt,PetscInt,PetscInt,PetscInt,PetscInt,const PetscInt*,PetscInt,const PetscInt*,Mat*);
  PetscErrorCode MatCreateSeqSBSTRM(MPI_Comm,PetscInt,PetscInt,PetscInt,PetscInt,const PetscInt*,Mat*);
  PetscErrorCode MatCreateMPISBSTRM(MPI_Comm,PetscInt,PetscInt,PetscInt,PetscInt,PetscInt,PetscInt,const PetscInt*,PetscInt,const PetscInt*,Mat*);

  PetscErrorCode MatCreateScatter(MPI_Comm,VecScatter,Mat*);
  PetscErrorCode MatScatterSetVecScatter(Mat,VecScatter);
  PetscErrorCode MatScatterGetVecScatter(Mat,VecScatter*);
  PetscErrorCode MatCreateBlockMat(MPI_Comm,PetscInt,PetscInt,PetscInt,PetscInt,PetscInt*,Mat*);
  PetscErrorCode MatCompositeAddMat(Mat,Mat);
  PetscErrorCode MatCompositeMerge(Mat);
  PetscErrorCode MatCreateComposite(MPI_Comm,PetscInt,const Mat*,Mat*);
}

Mat MatCreateSeqAIJ (PetscInt m,PetscInt n,PetscInt nz,const PetscInt* nnz) {Mat A; MatCreateSeqAIJ (PETSC_COMM_SELF,m,n,nz,nnz,&A);return A;}
Mat MatCreateSeqAIJ (PetscInt m,PetscInt n,PetscInt nz) {Mat A; MatCreateSeqAIJ (PETSC_COMM_SELF,m,n,nz,PETSC_NULL,&A);return A;}
Mat MatCreateSeqAIJ (PetscInt m,PetscInt n,const PetscInt* nnz) {Mat A; MatCreateSeqAIJ (PETSC_COMM_SELF,m,n,0,nnz,&A);return A;}
Mat MatCreateSeqAIJ (PetscInt m,PetscInt n) {Mat A; MatCreateSeqAIJ (PETSC_COMM_SELF,m,n,0,PETSC_NULL,&A);return A;}
PetscErrorCode MatCreateSeqAIJ (PetscInt m,PetscInt n,PetscInt nz,Mat *A) {return MatCreateSeqAIJ (PETSC_COMM_SELF,m,n,nz,PETSC_NULL,A);}
 PetscErrorCode MatCreateSeqAIJ (PetscInt m,PetscInt n,const PetscInt* nnz,Mat *A) {return MatCreateSeqAIJ (PETSC_COMM_SELF,m,n,0,nnz,A);}
PetscErrorCode MatCreateSeqAIJ (PetscInt m,PetscInt n,Mat *A) {return MatCreateSeqAIJ (PETSC_COMM_SELF,m,n,0,PETSC_NULL,A);}

Mat MatCreateMPIAIJ (MPI_Comm comm,PetscInt m,PetscInt n,PetscInt M,PetscInt N,PetscInt nz,const PetscInt* nnz,PetscInt onz,const PetscInt* onnz) {Mat A; MatCreateMPIAIJ (comm,m,n,M,N,nz,nnz,onz,onnz,&A);return A;}
Mat MatCreateMPIAIJ (MPI_Comm comm,PetscInt m,PetscInt n,PetscInt M,PetscInt N,PetscInt nz,PetscInt nnz) {Mat A; MatCreateMPIAIJ (comm,m,n,M,N,nz,PETSC_NULL,nnz,PETSC_NULL,&A);return A;}
Mat MatCreateMPIAIJ (MPI_Comm comm,PetscInt m,PetscInt n,PetscInt M,PetscInt N,const PetscInt* nnz,const PetscInt* onz) {Mat A; MatCreateMPIAIJ (comm,m,n,M,N,0,nnz,0,onz,&A);return A;}
Mat MatCreateMPIAIJ (MPI_Comm comm,PetscInt m,PetscInt n,PetscInt M,PetscInt N) {Mat A; MatCreateMPIAIJ (comm,m,n,M,N,0,PETSC_NULL,0,PETSC_NULL,&A);return A;}
PetscErrorCode MatCreateMPIAIJ (MPI_Comm comm,PetscInt m,PetscInt n,PetscInt M,PetscInt N,PetscInt nz,PetscInt nnz,Mat *A) {return MatCreateMPIAIJ (comm,m,n,M,N,nz,PETSC_NULL,nnz,PETSC_NULL,A);}
PetscErrorCode MatCreateMPIAIJ (MPI_Comm comm,PetscInt m,PetscInt n,PetscInt M,PetscInt N,const PetscInt* nnz,const PetscInt* onz,Mat *A) {return MatCreateMPIAIJ (comm,m,n,M,N,0,nnz,0,onz,A);}
PetscErrorCode MatCreateMPIAIJ (MPI_Comm comm,PetscInt m,PetscInt n,PetscInt M,PetscInt N,Mat *A) {return MatCreateMPIAIJ (comm,m,n,M,N,0,PETSC_NULL,0,PETSC_NULL,A);}
Mat MatCreateMPIAIJ (PetscInt m,PetscInt n,PetscInt M,PetscInt N,PetscInt nz,const PetscInt* nnz,PetscInt onz,const PetscInt* onnz) {Mat A; MatCreateMPIAIJ (PETSC_COMM_WORLD,m,n,M,N,nz,nnz,onz,onnz,&A);return A;}
Mat MatCreateMPIAIJ (PetscInt m,PetscInt n,PetscInt M,PetscInt N,PetscInt nz,PetscInt nnz) {Mat A; MatCreateMPIAIJ (PETSC_COMM_WORLD,m,n,M,N,nz,PETSC_NULL,nnz,PETSC_NULL,&A);return A;}
Mat MatCreateMPIAIJ (PetscInt m,PetscInt n,PetscInt M,PetscInt N,const PetscInt* nnz,const PetscInt* onz) {Mat A; MatCreateMPIAIJ (PETSC_COMM_WORLD,m,n,M,N,0,nnz,0,onz,&A);return A;}
Mat MatCreateMPIAIJ (PetscInt m,PetscInt n,PetscInt M,PetscInt N) {Mat A; MatCreateMPIAIJ (PETSC_COMM_WORLD,m,n,M,N,0,PETSC_NULL,0,PETSC_NULL,&A);return A;}
PetscErrorCode MatCreateMPIAIJ (PetscInt m,PetscInt n,PetscInt M,PetscInt N,PetscInt nz,PetscInt nnz,Mat *A) {return MatCreateMPIAIJ (PETSC_COMM_WORLD,m,n,M,N,nz,PETSC_NULL,nnz,PETSC_NULL,A);}
PetscErrorCode MatCreateMPIAIJ (PetscInt m,PetscInt n,PetscInt M,PetscInt N,const PetscInt* nnz,const PetscInt* onz,Mat *A) {return MatCreateMPIAIJ (PETSC_COMM_WORLD,m,n,M,N,0,nnz,0,onz,A);}
PetscErrorCode MatCreateMPIAIJ (PetscInt m,PetscInt n,PetscInt M,PetscInt N,Mat *A) {return MatCreateMPIAIJ (PETSC_COMM_WORLD,m,n,M,N,0,PETSC_NULL,0,PETSC_NULL,A);}

Mat MatCreateSeqBAIJ (PetscInt bs,PetscInt m,PetscInt n,PetscInt nz,const PetscInt* nnz) {Mat A; MatCreateSeqBAIJ (PETSC_COMM_SELF,bs,m,n,nz,nnz,&A);return A;}
Mat MatCreateSeqBAIJ (PetscInt bs,PetscInt m,PetscInt n,PetscInt nz) {Mat A; MatCreateSeqBAIJ (PETSC_COMM_SELF,bs,m,n,nz,PETSC_NULL,&A);return A;}
Mat MatCreateSeqBAIJ (PetscInt bs,PetscInt m,PetscInt n,const PetscInt* nnz) {Mat A; MatCreateSeqBAIJ (PETSC_COMM_SELF,bs,m,n,0,nnz,&A);return A;}
Mat MatCreateSeqBAIJ (PetscInt bs,PetscInt m,PetscInt n) {Mat A; MatCreateSeqBAIJ (PETSC_COMM_SELF,bs,m,n,0,PETSC_NULL,&A);return A;}
PetscErrorCode MatCreateSeqBAIJ (PetscInt bs,PetscInt m,PetscInt n,PetscInt nz,Mat *A) {return MatCreateSeqBAIJ (PETSC_COMM_SELF,bs,m,n,nz,PETSC_NULL,A);}
PetscErrorCode MatCreateSeqBAIJ (PetscInt bs,PetscInt m,PetscInt n,const PetscInt* nnz,Mat *A) {return MatCreateSeqBAIJ (PETSC_COMM_SELF,bs,m,n,0,nnz,A);}
PetscErrorCode MatCreateSeqBAIJ (PetscInt bs,PetscInt m,PetscInt n,Mat *A) {return MatCreateSeqBAIJ (PETSC_COMM_SELF,bs,m,n,0,PETSC_NULL,A);}

Mat MatCreateMPIBAIJ (MPI_Comm comm,PetscInt bs,PetscInt m,PetscInt n,PetscInt M,PetscInt N,PetscInt nz,const PetscInt* nnz,PetscInt onz,const PetscInt* onnz) {Mat A; MatCreateMPIBAIJ (comm,bs,m,n,M,N,nz,nnz,onz,onnz,&A);return A;}
Mat MatCreateMPIBAIJ (MPI_Comm comm,PetscInt bs,PetscInt m,PetscInt n,PetscInt M,PetscInt N,PetscInt nz,PetscInt nnz) {Mat A; MatCreateMPIBAIJ (comm,bs,m,n,M,N,nz,PETSC_NULL,nnz,PETSC_NULL,&A);return A;}
Mat MatCreateMPIBAIJ (MPI_Comm comm,PetscInt bs,PetscInt m,PetscInt n,PetscInt M,PetscInt N,const PetscInt* nnz,const PetscInt* onz) {Mat A; MatCreateMPIBAIJ (comm,bs,m,n,M,N,0,nnz,0,onz,&A);return A;}
Mat MatCreateMPIBAIJ (MPI_Comm comm,PetscInt bs,PetscInt m,PetscInt n,PetscInt M,PetscInt N) {Mat A; MatCreateMPIBAIJ (comm,bs,m,n,M,N,0,PETSC_NULL,0,PETSC_NULL,&A);return A;}
PetscErrorCode MatCreateMPIBAIJ (MPI_Comm comm,PetscInt bs,PetscInt m,PetscInt n,PetscInt M,PetscInt N,PetscInt nz,PetscInt nnz,Mat *A) {return MatCreateMPIBAIJ (comm,bs,m,n,M,N,nz,PETSC_NULL,nnz,PETSC_NULL,A);}
PetscErrorCode MatCreateMPIBAIJ (MPI_Comm comm,PetscInt bs,PetscInt m,PetscInt n,PetscInt M,PetscInt N,const PetscInt* nnz,const PetscInt* onz,Mat *A) {return MatCreateMPIBAIJ (comm,bs,m,n,M,N,0,nnz,0,onz,A);}
PetscErrorCode MatCreateMPIBAIJ (MPI_Comm comm,PetscInt bs,PetscInt m,PetscInt n,PetscInt M,PetscInt N,Mat *A) {return MatCreateMPIBAIJ (comm,bs,m,n,M,N,0,PETSC_NULL,0,PETSC_NULL,A);}
Mat MatCreateMPIBAIJ (PetscInt bs,PetscInt m,PetscInt n,PetscInt M,PetscInt N,PetscInt nz,const PetscInt* nnz,PetscInt onz,const PetscInt* onnz) {Mat A; MatCreateMPIBAIJ (PETSC_COMM_WORLD,bs,m,n,M,N,nz,nnz,onz,onnz,&A);return A;}
Mat MatCreateMPIBAIJ (PetscInt bs,PetscInt m,PetscInt n,PetscInt M,PetscInt N,PetscInt nz,PetscInt nnz) {Mat A; MatCreateMPIBAIJ (PETSC_COMM_WORLD,bs,m,n,M,N,nz,PETSC_NULL,nnz,PETSC_NULL,&A);return A;}
Mat MatCreateMPIBAIJ (PetscInt bs,PetscInt m,PetscInt n,PetscInt M,PetscInt N,const PetscInt* nnz,const PetscInt* onz) {Mat A; MatCreateMPIBAIJ (PETSC_COMM_WORLD,bs,m,n,M,N,0,nnz,0,onz,&A);return A;}
Mat MatCreateMPIBAIJ (PetscInt bs,PetscInt m,PetscInt n,PetscInt M,PetscInt N) {Mat A; MatCreateMPIBAIJ (PETSC_COMM_WORLD,bs,m,n,M,N,0,PETSC_NULL,0,PETSC_NULL,&A);return A;}
PetscErrorCode MatCreateMPIBAIJ (PetscInt bs,PetscInt m,PetscInt n,PetscInt M,PetscInt N,PetscInt nz,PetscInt nnz,Mat *A) {return MatCreateMPIBAIJ (PETSC_COMM_WORLD,bs,m,n,M,N,nz,PETSC_NULL,nnz,PETSC_NULL,A);}
PetscErrorCode MatCreateMPIBAIJ (PetscInt bs,PetscInt m,PetscInt n,PetscInt M,PetscInt N,const PetscInt* nnz,const PetscInt* onz,Mat *A) {return MatCreateMPIBAIJ (PETSC_COMM_WORLD,bs,m,n,M,N,0,nnz,0,onz,A);}
PetscErrorCode MatCreateMPIBAIJ (PetscInt bs,PetscInt m,PetscInt n,PetscInt M,PetscInt N,Mat *A) {return MatCreateMPIBAIJ (PETSC_COMM_WORLD,bs,m,n,M,N,0,PETSC_NULL,0,PETSC_NULL,A);}

Mat MatCreateSeqSBAIJ (PetscInt bs,PetscInt m,PetscInt n,PetscInt nz,const PetscInt* nnz) {Mat A; MatCreateSeqSBAIJ (PETSC_COMM_SELF,bs,m,n,nz,nnz,&A);return A;}
Mat MatCreateSeqSBAIJ (PetscInt bs,PetscInt m,PetscInt n,PetscInt nz) {Mat A; MatCreateSeqSBAIJ (PETSC_COMM_SELF,bs,m,n,nz,PETSC_NULL,&A);return A;}
Mat MatCreateSeqSBAIJ (PetscInt bs,PetscInt m,PetscInt n,const PetscInt* nnz) {Mat A; MatCreateSeqSBAIJ (PETSC_COMM_SELF,bs,m,n,0,nnz,&A);return A;}
Mat MatCreateSeqSBAIJ (PetscInt bs,PetscInt m,PetscInt n) {Mat A; MatCreateSeqSBAIJ (PETSC_COMM_SELF,bs,m,n,0,PETSC_NULL,&A);return A;}
PetscErrorCode MatCreateSeqSBAIJ (PetscInt bs,PetscInt m,PetscInt n,const PetscInt* nnz,Mat *A) {return MatCreateSeqSBAIJ (PETSC_COMM_SELF,bs,m,n,0,nnz,A);}
PetscErrorCode MatCreateSeqSBAIJ (PetscInt bs,PetscInt m,PetscInt n,Mat *A) {return MatCreateSeqSBAIJ (PETSC_COMM_SELF,bs,m,n,0,PETSC_NULL,A);}

Mat MatCreateMPISBAIJ (MPI_Comm comm,PetscInt bs,PetscInt m,PetscInt n,PetscInt M,PetscInt N,PetscInt nz,const PetscInt* nnz,PetscInt onz,const PetscInt* onnz) {Mat A; MatCreateMPISBAIJ (comm,bs,m,n,M,N,nz,nnz,onz,onnz,&A);return A;}
Mat MatCreateMPISBAIJ (MPI_Comm comm,PetscInt bs,PetscInt m,PetscInt n,PetscInt M,PetscInt N,PetscInt nz,PetscInt nnz) {Mat A; MatCreateMPISBAIJ (comm,bs,m,n,M,N,nz,PETSC_NULL,nnz,PETSC_NULL,&A);return A;}
Mat MatCreateMPISBAIJ (MPI_Comm comm,PetscInt bs,PetscInt m,PetscInt n,PetscInt M,PetscInt N,const PetscInt* nnz,const PetscInt* onz) {Mat A; MatCreateMPISBAIJ (comm,bs,m,n,M,N,0,nnz,0,onz,&A);return A;}
Mat MatCreateMPISBAIJ (MPI_Comm comm,PetscInt bs,PetscInt m,PetscInt n,PetscInt M,PetscInt N) {Mat A; MatCreateMPISBAIJ (comm,bs,m,n,M,N,0,PETSC_NULL,0,PETSC_NULL,&A);return A;}
PetscErrorCode MatCreateMPISBAIJ (MPI_Comm comm,PetscInt bs,PetscInt m,PetscInt n,PetscInt M,PetscInt N,PetscInt nz,PetscInt nnz,Mat *A) {return MatCreateMPISBAIJ (comm,bs,m,n,M,N,nz,PETSC_NULL,nnz,PETSC_NULL,A);}
PetscErrorCode MatCreateMPISBAIJ (MPI_Comm comm,PetscInt bs,PetscInt m,PetscInt n,PetscInt M,PetscInt N,const PetscInt* nnz,const PetscInt* onz,Mat *A) {return MatCreateMPISBAIJ (comm,bs,m,n,M,N,0,nnz,0,onz,A);}
PetscErrorCode MatCreateMPISBAIJ (MPI_Comm comm,PetscInt bs,PetscInt m,PetscInt n,PetscInt M,PetscInt N,Mat *A) {return MatCreateMPISBAIJ (comm,bs,m,n,M,N,0,PETSC_NULL,0,PETSC_NULL,A);}
Mat MatCreateMPISBAIJ (PetscInt bs,PetscInt m,PetscInt n,PetscInt M,PetscInt N,PetscInt nz,const PetscInt* nnz,PetscInt onz,const PetscInt* onnz) {Mat A; MatCreateMPISBAIJ (PETSC_COMM_WORLD,bs,m,n,M,N,nz,nnz,onz,onnz,&A);return A;}
Mat MatCreateMPISBAIJ (PetscInt bs,PetscInt m,PetscInt n,PetscInt M,PetscInt N,PetscInt nz,PetscInt nnz) {Mat A; MatCreateMPISBAIJ (PETSC_COMM_WORLD,bs,m,n,M,N,nz,PETSC_NULL,nnz,PETSC_NULL,&A);return A;}
Mat MatCreateMPISBAIJ (PetscInt bs,PetscInt m,PetscInt n,PetscInt M,PetscInt N,const PetscInt* nnz,const PetscInt* onz) {Mat A; MatCreateMPISBAIJ (PETSC_COMM_WORLD,bs,m,n,M,N,0,nnz,0,onz,&A);return A;}
Mat MatCreateMPISBAIJ (PetscInt bs,PetscInt m,PetscInt n,PetscInt M,PetscInt N) {Mat A; MatCreateMPISBAIJ (PETSC_COMM_WORLD,bs,m,n,M,N,0,PETSC_NULL,0,PETSC_NULL,&A);return A;}
PetscErrorCode MatCreateMPISBAIJ (PetscInt bs,PetscInt m,PetscInt n,PetscInt M,PetscInt N,PetscInt nz,PetscInt nnz,Mat *A) {return MatCreateMPISBAIJ (PETSC_COMM_WORLD,bs,m,n,M,N,nz,PETSC_NULL,nnz,PETSC_NULL,A);}
PetscErrorCode MatCreateMPISBAIJ (PetscInt bs,PetscInt m,PetscInt n,PetscInt M,PetscInt N,const PetscInt* nnz,const PetscInt* onz,Mat *A) {return MatCreateMPISBAIJ (PETSC_COMM_WORLD,bs,m,n,M,N,0,nnz,0,onz,A);}
PetscErrorCode MatCreateMPISBAIJ (PetscInt bs,PetscInt m,PetscInt n,PetscInt M,PetscInt N,Mat *A) {return MatCreateMPISBAIJ (PETSC_COMM_WORLD,bs,m,n,M,N,0,PETSC_NULL,0,PETSC_NULL,A);}

Mat MatCreateShell (MPI_Comm comm,PetscInt m,PetscInt n,PetscInt M,PetscInt N,void *ctx) {Mat A; MatCreateShell (comm,m,n,M,N,ctx,&A);return A;}
Mat MatCreateShell (PetscInt m,PetscInt n,PetscInt M,PetscInt N,void *ctx) {Mat A; MatCreateShell (PETSC_COMM_WORLD,m,n,M,N,ctx,&A);return A;}

Mat MatCreateNormal (Mat mat) {Mat A; MatCreateNormal (mat,&A);return A;}