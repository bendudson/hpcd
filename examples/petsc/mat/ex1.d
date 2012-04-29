

auto help =  "Reads a PETSc matrix and vector from a file and reorders it.\n
  -f0 <input_file> : first file to load (small system)\n
  -f1 <input_file> : second file to load (larger system)\n\n";

import petsc.c.mat;
import petsc.c.sys;
import petsc.c.viewer;
import petsc.c.IS;

int main(string[] args) {
  Mat                   A;                /* matrix */
  PetscViewer           fd;               /* viewer */
  string                file[2];          /* input file name */
  IS                    isrow,iscol;      /* row and column permutations */
  PetscErrorCode        ierr;
  
  PetscInitialize(args, help);
  scope(exit) PetscFinalize(); // Ensures a call when finished
  
  
  
  return 0;
}
