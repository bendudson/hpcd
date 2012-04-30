

auto help =  "Reads a PETSc matrix and vector from a file and reorders it.\n
  -f0 <input_file> : first file to load (small system)\n
  -f1 <input_file> : second file to load (larger system)\n\n";

import petsc.c.mat;
import petsc.c.sys;
import petsc.c.viewer;
import petsc.c.options;
import petsc.c.IS;

import std.stdio;

int main(string[] args) {
  Mat                   A;                /* matrix */
  PetscViewer           fd;               /* viewer */
  string                file[2];          /* input file name */
  IS                    isrow,iscol;      /* row and column permutations */
  PetscErrorCode        ierr;
  
  PetscInitialize(args, help);
  scope(exit) PetscFinalize(); // Ensures a call when finished
  
  PetscBool flg, PetscPreLoad = PetscBool.FALSE;
  ierr = PetscOptionsGetString(PETSC_NULL,"-f0",file[0],flg);CHKERRQ(ierr);
  //if (!flg) SETERRQ(PETSC_COMM_WORLD,1,"Must indicate binary file with the -f0 option");
  writefln("f0: %s, %d", file[0],file[0].length);
  ierr = PetscOptionsGetString(PETSC_NULL,"-f1",file[1],flg);CHKERRQ(ierr);
  if (flg) PetscPreLoad = PetscBool.TRUE;

  /* -----------------------------------------------------------
                  Beginning of loop
     ----------------------------------------------------------- */
  /* 
     Loop through the reordering 2 times.  
      - The intention here is to preload and solve a small system;
        then load another (larger) system and solve it as well.
        This process preloads the instructions with the smaller
        system so that more accurate performance monitoring (via
        -log_summary) can be done with the larger one (that actually
        is the system of interest). 
  */
  //PetscPreLoadBegin(PetscPreLoad,"Load");
  
  /* - - - - - - - - - - - New Stage - - - - - - - - - - - - -
     Load system i
     - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  /* 
     Open binary file.  Note that we use FILE_MODE_READ to indicate
     reading from this file.
  */
  ierr = PetscViewerBinaryOpen(PETSC_COMM_WORLD,file[PetscPreLoadIt],FILE_MODE_READ,&fd);CHKERRQ(ierr);
  
  /*
    Load the matrix; then destroy the viewer.
  */
  ierr = MatCreate(PETSC_COMM_WORLD,&A);CHKERRQ(ierr);
  ierr = MatSetType(A,MATSEQAIJ);CHKERRQ(ierr);
  ierr = MatLoad(A,fd);CHKERRQ(ierr);
  ierr = PetscViewerDestroy(&fd);CHKERRQ(ierr);
  
  /* - - - - - - - - - - - New Stage - - - - - - - - - - - - -
     - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
  
  //PetscPreLoadStage("Reordering");
  ierr = MatGetOrdering(A,rtype,&isrow,&iscol);CHKERRQ(ierr);

  /* 
     Free work space.  All PETSc objects should be destroyed when they
     are no longer needed.
  */
  ierr = MatDestroy(&A);CHKERRQ(ierr);
  ierr = ISDestroy(&isrow);CHKERRQ(ierr);
  ierr = ISDestroy(&iscol);CHKERRQ(ierr);
  //PetscPreLoadEnd();
  
  return 0;
}
