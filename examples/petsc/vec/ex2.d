/*
  
 */

import petsc.c.vec;
import petsc.c.sys;
import petsc.c.viewer;

auto help = "Builds a parallel vector with 1 component on the firstprocessor, 2 on the second, etc.\n
Then each processor adds one to all elements except the last rank.\n\n";

int main(string[] args) {
  PetscErrorCode ierr;
  
  PetscInitialize(args, help);
  
  int rank = MPI_Comm_rank(PETSC_COMM_WORLD);
  
  /*
     Create a parallel vector.
      - In this case, we specify the size of each processor's local
        portion, and PETSc computes the global size.  Alternatively,
        if we pass the global size and use PETSC_DECIDE for the 
        local size PETSc will choose a reasonable partition trying 
        to put nearly an equal number of elements on each processor.
  */
  Vec            x;
  PetscInt       N;
  PetscScalar    one = 1.0;
  ierr = VecCreate(PETSC_COMM_WORLD,&x);CHKERRQ(ierr);
  ierr = VecSetSizes(x,rank+1,PETSC_DECIDE);CHKERRQ(ierr);
  ierr = VecSetFromOptions(x);CHKERRQ(ierr);
  ierr = VecGetSize(x,&N);CHKERRQ(ierr);
  ierr = VecSet(x,one);CHKERRQ(ierr);
  /*
     Set the vector elements.
      - Always specify global locations of vector entries.
      - Each processor can contribute any vector entries,
        regardless of which processor "owns" them; any nonlocal
        contributions will be transferred to the appropriate processor
        during the assembly process.
      - In this example, the flag ADD_VALUES indicates that all
        contributions will be added together.
  */
  for (int i=0; i<N-rank; i++) {
    ierr = VecSetValues(x,1,&i,&one,InsertMode.ADD_VALUES);CHKERRQ(ierr);  
  }

  /* 
     Assemble vector, using the 2-step process:
       VecAssemblyBegin(), VecAssemblyEnd()
     Computations can be done while messages are in transition
     by placing code between these two statements.
  */
  ierr = VecAssemblyBegin(x);CHKERRQ(ierr);
  ierr = VecAssemblyEnd(x);CHKERRQ(ierr);

  /*
      View the vector; then destroy it.
  */
  ierr = VecView(x,PETSC_VIEWER_STDOUT_WORLD);CHKERRQ(ierr);
  ierr = VecDestroy(&x);CHKERRQ(ierr);
  
  PetscFinalize();
  return 0;
}