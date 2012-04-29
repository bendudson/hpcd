
auto help = "Basic vector routines.\n\n";

import petsc.c.sys;
import petsc.c.vec;
import petsc.c.options;

import std.math;

int main(string[] args) {
  PetscErrorCode ierr;
  
  PetscInitialize(args, help);
  
  
  PetscInt       n = 20;
  ierr = PetscOptionsGetInt("-n",&n,null);CHKERRQ(ierr);
  
  Vec            x,y,w;               /* vectors */
  Vec            *z;                  /* array of vectors */
  
  /* 
     Create a vector, specifying only its global dimension.
     When using VecCreate(), VecSetSizes() and VecSetFromOptions(), the vector format 
     (currently parallel, shared, or sequential) is determined at runtime.  Also, the 
     parallel partitioning of the vector is determined by PETSc at runtime.

     Routines for creating particular vector types directly are:
        VecCreateSeq() - uniprocessor vector
        VecCreateMPI() - distributed vector, where the user can
                         determine the parallel partitioning
        VecCreateShared() - parallel vector that uses shared memory
                            (available only on the SGI); otherwise,
                            is the same as VecCreateMPI()

     With VecCreate(), VecSetSizes() and VecSetFromOptions() the option -vec_type mpi or 
     -vec_type shared causes the particular type of vector to be formed.
y

  */
  ierr = VecCreate(PETSC_COMM_WORLD,&x);CHKERRQ(ierr);
  ierr = VecSetSizes(x,PETSC_DECIDE,n);CHKERRQ(ierr);
  ierr = VecSetFromOptions(x);CHKERRQ(ierr);
/*
     Duplicate some work vectors (of the same format and
     partitioning as the initial vector).
  */
  ierr = VecDuplicate(x,&y);CHKERRQ(ierr);
  ierr = VecDuplicate(x,&w);CHKERRQ(ierr);
  PetscReal norm;
  ierr = VecNorm(w,NormType.NORM_2,&norm);CHKERRQ(ierr);
  /*
     Duplicate more work vectors (of the same format and
     partitioning as the initial vector).  Here we duplicate
     an array of vectors, which is often more convenient than
     duplicating individual ones.
  */
  ierr = VecDuplicateVecs(x,3,&z);CHKERRQ(ierr); 
  /*
     Set the vectors to entries to a constant value.
  */
  PetscScalar    one = 1.0,two = 2.0,three = 3.0;
  ierr = VecSet(x,one);CHKERRQ(ierr);
  ierr = VecSet(y,two);CHKERRQ(ierr);
  ierr = VecSet(z[0],one);CHKERRQ(ierr);
  ierr = VecSet(z[1],two);CHKERRQ(ierr);
  ierr = VecSet(z[2],three);CHKERRQ(ierr);
  /*
     Demonstrate various basic vector routines.
  */
  PetscScalar dots[3];
  PetscScalar dot;
  ierr = VecDot(x,x,&dot);CHKERRQ(ierr);
  ierr = VecMDot(x,3,z,dots);CHKERRQ(ierr);
  
  ierr = PetscPrintf(PETSC_COMM_WORLD,"Vector length %D\n", cast(PetscInt) dot); CHKERRQ(ierr);
  ierr = PetscPrintf(PETSC_COMM_WORLD,"Vector length %D %D %D\n",cast(PetscInt)dots[0],
                             cast(PetscInt)dots[1],cast(PetscInt)dots[2]);CHKERRQ(ierr);
  
  PetscInt maxind;
  PetscReal maxval;
  ierr = VecMax(x,&maxind,&maxval);CHKERRQ(ierr);
  ierr = PetscPrintf(PETSC_COMM_WORLD,"VecMax %g, VecInd %D\n",cast(double)maxval,maxind);CHKERRQ(ierr);

  ierr = VecMin(x,&maxind,&maxval);CHKERRQ(ierr);
  ierr = PetscPrintf(PETSC_COMM_WORLD,"VecMin %g, VecInd %D\n",cast(double)maxval,maxind);CHKERRQ(ierr);
  
  ierr = PetscPrintf(PETSC_COMM_WORLD,"All other values should be near zero\n");CHKERRQ(ierr);

  ierr = VecScale(x,two);CHKERRQ(ierr);
  ierr = VecNorm(x,NormType.NORM_2,&norm);CHKERRQ(ierr);
  PetscReal v = norm-2.0*sqrt(cast(double)n); if (v > -PETSC_SMALL && v < PETSC_SMALL) v = 0.0; 
  ierr = PetscPrintf(PETSC_COMM_WORLD,"VecScale %g\n",cast(double)v);CHKERRQ(ierr);

  ierr = VecCopy(x,w);CHKERRQ(ierr);
  ierr = VecNorm(w,NormType.NORM_2,&norm);CHKERRQ(ierr);
  v = norm-2.0*sqrt(cast(double)n); if (v > -PETSC_SMALL && v < PETSC_SMALL) v = 0.0; 
  ierr = PetscPrintf(PETSC_COMM_WORLD,"VecCopy  %g\n",cast(double)v);CHKERRQ(ierr);

  ierr = VecAXPY(y,three,x);CHKERRQ(ierr);
  ierr = VecNorm(y,NormType.NORM_2,&norm);CHKERRQ(ierr);
  v = norm-8.0*sqrt(cast(double)n); if (v > -PETSC_SMALL && v < PETSC_SMALL) v = 0.0; 
  ierr = PetscPrintf(PETSC_COMM_WORLD,"VecAXPY %g\n",cast(double)v);CHKERRQ(ierr);

  ierr = VecAYPX(y,two,x);CHKERRQ(ierr);
  ierr = VecNorm(y,NormType.NORM_2,&norm);CHKERRQ(ierr);
  v = norm-18.0*sqrt(cast(double)n); if (v > -PETSC_SMALL && v < PETSC_SMALL) v = 0.0; 
  ierr = PetscPrintf(PETSC_COMM_WORLD,"VecAYPX %g\n",cast(double)v);CHKERRQ(ierr);

  ierr = VecSwap(x,y);CHKERRQ(ierr);
  ierr = VecNorm(y,NormType.NORM_2,&norm);CHKERRQ(ierr);
  v = norm-2.0*sqrt(cast(double)n); if (v > -PETSC_SMALL && v < PETSC_SMALL) v = 0.0; 
  ierr = PetscPrintf(PETSC_COMM_WORLD,"VecSwap  %g\n",cast(double)v);CHKERRQ(ierr);
  ierr = VecNorm(x,NormType.NORM_2,&norm);CHKERRQ(ierr);
  v = norm-18.0*sqrt(cast(double)n); if (v > -PETSC_SMALL && v < PETSC_SMALL) v = 0.0; 
  ierr = PetscPrintf(PETSC_COMM_WORLD,"VecSwap  %g\n",cast(double)v);CHKERRQ(ierr);

  ierr = VecWAXPY(w,two,x,y);CHKERRQ(ierr);
  ierr = VecNorm(w,NormType.NORM_2,&norm);CHKERRQ(ierr);
  v = norm-38.0*sqrt(cast(double)n); if (v > -PETSC_SMALL && v < PETSC_SMALL) v = 0.0; 
  ierr = PetscPrintf(PETSC_COMM_WORLD,"VecWAXPY %g\n",cast(double)v);CHKERRQ(ierr);

  ierr = VecPointwiseMult(w,y,x);CHKERRQ(ierr);
  ierr = VecNorm(w,NormType.NORM_2,&norm);CHKERRQ(ierr); 
  v = norm-36.0*sqrt(cast(double)n); if (v > -PETSC_SMALL && v < PETSC_SMALL) v = 0.0; 
  ierr = PetscPrintf(PETSC_COMM_WORLD,"VecPointwiseMult %g\n",cast(double)v);CHKERRQ(ierr);

  ierr = VecPointwiseDivide(w,x,y);CHKERRQ(ierr);
  ierr = VecNorm(w,NormType.NORM_2,&norm);CHKERRQ(ierr);
  v = norm-9.0*sqrt(cast(double)n); if (v > -PETSC_SMALL && v < PETSC_SMALL) v = 0.0; 
  ierr = PetscPrintf(PETSC_COMM_WORLD,"VecPointwiseDivide %g\n",cast(double)v);CHKERRQ(ierr);

  dots[0] = one;
  dots[1] = three;
  dots[2] = two;
  ierr = VecSet(x,one);CHKERRQ(ierr);
  ierr = VecMAXPY(x,3,dots,z);CHKERRQ(ierr);
  ierr = VecNorm(z[0],NormType.NORM_2,&norm);CHKERRQ(ierr);
  v = norm-sqrt(cast(double)n); if (v > -PETSC_SMALL && v < PETSC_SMALL) v = 0.0; 
  ierr = VecNorm(z[1],NormType.NORM_2,&norm);CHKERRQ(ierr);
  PetscReal v1 = norm-2.0*sqrt(cast(double)n); if (v1 > -PETSC_SMALL && v1 < PETSC_SMALL) v1 = 0.0; 
  ierr = VecNorm(z[2],NormType.NORM_2,&norm);CHKERRQ(ierr);
  PetscReal v2 = norm-3.0*sqrt(cast(double)n); if (v2 > -PETSC_SMALL && v2 < PETSC_SMALL) v2 = 0.0; 
  ierr = PetscPrintf(PETSC_COMM_WORLD,"VecMAXPY %g %g %g \n",cast(double)v,cast(double)v1,cast(double)v2);CHKERRQ(ierr);
  
  /* 
     Free work space.  All PETSc objects should be destroyed when they
     are no longer needed.
  */
  ierr = VecDestroy(&x);CHKERRQ(ierr);
  ierr = VecDestroy(&y);CHKERRQ(ierr);
  ierr = VecDestroy(&w);CHKERRQ(ierr);
  ierr = VecDestroyVecs(3,&z);CHKERRQ(ierr);
  
  PetscFinalize();
  
  return 0;
}
