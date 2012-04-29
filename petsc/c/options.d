
import petsc.c.types;
import petsc.c.error;
import petsc.c.viewer;
import mpi.mpi : MPI_Comm;

extern(C) {
  
  PetscErrorCode   PetscOptionsHasName(const char*,const char*,PetscBool *);
  PetscErrorCode   PetscOptionsGetInt(const char*,const char*,PetscInt *,PetscBool *);
  PetscErrorCode   PetscOptionsGetBool(const char*,const char*,PetscBool  *,PetscBool *);
  PetscErrorCode   PetscOptionsGetReal(const char*,const char*,PetscReal *,PetscBool *);
  PetscErrorCode   PetscOptionsGetScalar(const char*,const char*,PetscScalar *,PetscBool *);
  PetscErrorCode   PetscOptionsGetIntArray(const char*,const char*,PetscInt*,PetscInt *,PetscBool *);
  PetscErrorCode   PetscOptionsGetRealArray(const char*,const char*,PetscReal*,PetscInt *,PetscBool *);
  PetscErrorCode   PetscOptionsGetBoolArray(const char*,const char*,PetscBool*,PetscInt *,PetscBool *);
  PetscErrorCode   PetscOptionsGetString(const char*,const char*,char*,size_t,PetscBool *);
  PetscErrorCode   PetscOptionsGetStringArray(const char*,const char*,char**,PetscInt*,PetscBool *);
  PetscErrorCode  PetscOptionsGetEList(const char*,const char*,const char**,PetscInt,PetscInt*,PetscBool *);
  PetscErrorCode  PetscOptionsGetEnum(const char*,const char*,const char**,PetscEnum*,PetscBool *);
  PetscErrorCode  PetscOptionsValidKey(const char*,PetscBool *);
  
  PetscErrorCode   PetscOptionsSetAlias(const char*,const char*);
  PetscErrorCode   PetscOptionsSetValue(const char*,const char*);
  PetscErrorCode   PetscOptionsClearValue(const char*);

  PetscErrorCode   PetscOptionsAllUsed(PetscInt*);
  PetscErrorCode   PetscOptionsLeft();
  PetscErrorCode   PetscOptionsView(PetscViewer);

  PetscErrorCode   PetscOptionsCreate();
  PetscErrorCode   PetscOptionsInsert(int*,char ***,const char*);
  PetscErrorCode   PetscOptionsInsertFile(MPI_Comm,const char*,PetscBool );
  PetscErrorCode   PetscOptionsInsertString(const char*);
  PetscErrorCode   PetscOptionsDestroy();
  PetscErrorCode   PetscOptionsClear();
  PetscErrorCode   PetscOptionsPrefixPush(const char*);
  PetscErrorCode   PetscOptionsPrefixPop();

  PetscErrorCode   PetscOptionsReject(const char*,const char*);
  PetscErrorCode   PetscOptionsGetAll(char**);

  PetscErrorCode   PetscOptionsGetenv(MPI_Comm,const char*,char*,size_t,PetscBool  *);
  PetscErrorCode   PetscOptionsStringToInt(const char*,PetscInt*);
  PetscErrorCode   PetscOptionsStringToReal(const char*,PetscReal*);
  PetscErrorCode   PetscOptionsStringToBool(const char*,PetscBool*);

  PetscErrorCode  PetscOptionsMonitorSet(PetscErrorCode function(const char*, const char*, void*), void *, PetscErrorCode function(void**));
  PetscErrorCode  PetscOptionsMonitorCancel();
  PetscErrorCode  PetscOptionsMonitorDefault(const char*, const char*, void *);
}

// Global variables
extern(C) {
  extern __gshared PetscBool  PetscOptionsPublish;
  extern __gshared PetscInt   PetscOptionsPublishCount;
}

// Polymorphic functions
PetscErrorCode   PetscOptionsHasName(const char* b,PetscBool  *f) {
  return PetscOptionsHasName(null,b,f);
}

PetscErrorCode   PetscOptionsGetInt(const char* b,PetscInt *i,PetscBool  *f) {
  return PetscOptionsGetInt(null,b,i,f);
}

PetscErrorCode   PetscOptionsGetBool(const char* b,PetscBool  *i,PetscBool  *f) {
  return PetscOptionsGetBool(null,b,i,f);
}

PetscErrorCode   PetscOptionsGetReal(const char* b,PetscReal *i,PetscBool  *f) {
  return PetscOptionsGetReal(null,b,i,f);
}

PetscErrorCode   PetscOptionsGetScalar(const char* b,PetscScalar* i,PetscBool  *f) {
  return PetscOptionsGetScalar(null,b,i,f);
}

PetscErrorCode   PetscOptionsGetIntArray(const char* b,PetscInt* i,PetscInt *ii,PetscBool  *f) {
  return PetscOptionsGetIntArray(null,b,i,ii,f);
}

PetscErrorCode   PetscOptionsGetRealArray(const char* b,PetscReal* i,PetscInt *ii,PetscBool  *f) {
  return PetscOptionsGetRealArray(null,b,i,ii,f);
}

PetscErrorCode   PetscOptionsGetBoolArray(const char* b,PetscBool*  i,PetscInt *ii,PetscBool  *f) {
  return PetscOptionsGetBoolArray(null,b,i,ii,f);
}

PetscErrorCode   PetscOptionsGetString(const char* b,char* i,size_t s,PetscBool  *f) {
  return PetscOptionsGetString(null,b,i,s,f);
}

PetscErrorCode   PetscOptionsGetStringArray(const char* b,char** i,PetscInt *ii,PetscBool  *f) {
  return PetscOptionsGetStringArray(null,b,i,ii,f);
}


