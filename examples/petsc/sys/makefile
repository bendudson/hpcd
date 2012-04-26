
SOURCED = ex3.d

PETSCTARGET = ex3

PETSCLIBS = ${PETSC_KSP_LIB}

TOP = ../../..

LIBS =  $(TOP)/petsc/libpetsc.lib $(TOP)/mpi/libmpi.lib $(DLIBS)

.PHONY:all
all: $(PETSCTARGET)

$(PETSCTARGET): ex3.o
	-${CLINKER} -o $(PETSCTARGET) $(OBJC) $(OBJD) $(LIBS) $(PETSCLIBS) 

include $(TOP)/make.config
include ${PETSC_DIR}/conf/variables
include ${PETSC_DIR}/conf/rules

