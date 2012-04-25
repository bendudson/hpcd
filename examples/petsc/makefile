
SOURCED = ex1.d

PETSCTARGET = ex1

PETSCLIBS = ${PETSC_KSP_LIB}

LIBROOT = ../..

DINCLUDE = -I$(LIBROOT)
LIBS =  $(LIBROOT)/petsc/libpetsc.lib $(DLIBS)

.PHONY:all
all: $(PETSCTARGET)

$(PETSCTARGET): ex1.o
	-${CLINKER} -o $(PETSCTARGET) $(OBJC) $(OBJD) $(LIBS) $(PETSCLIBS) 

include ../../make.config
include ${PETSC_DIR}/conf/variables
include ${PETSC_DIR}/conf/rules

