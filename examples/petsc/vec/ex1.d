
auto help = "Basic vector routines.\n\n";

import petsc.c.sys;
import petsc.c.vec;

int main(string[] args) {
  PetscErrorCode ierr;
  
  PetscInitialize(args, help);
  
  
  PetscInt       n = 20;
  ierr = PetscOptionsGetInt(PETSC_NULL,"-n",&n,PETSC_NULL);CHKERRQ(ierr);
  
  Vec            x,y,w;               /* vectors */
  Vec            *z;                  /* array of vectors */
  
  

  PetscFinalize();
  
  return 0;
}
