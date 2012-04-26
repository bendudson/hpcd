
TOP = ../..

EXAMPLES = example_01.d example_02.d

OBJD    = $(EXAMPLES:%.d=%.o)
TARGET = $(EXAMPLES:%.d=%)

LIBS =  $(TOP)/mpi/libmpi.lib $(DLIBS)

.PHONY: all
all: $(TARGET)

%: %.o 
	$(CC) -o $@ $<  $(LIBS)

include ../../make.config

