

auto help = "Augmenting PETSc profiling by add events.\n
Run this program with one of the\n
following options to generate logging information:  -log, -log_summary,\n
-log_all.  The PETSc routines automatically log event times and flops,\n
so this monitoring is intended solely for users to employ in application\n
codes.\n\n";

import petsc.c.sys;
import petsc.c.log;

int main(string[] args) {
  PetscErrorCode ierr;
  PetscLogEvent  USER_EVENT;
  
  int imax = 10000;

  PetscInitialize(args, help);
  
  /* 
     Create a new user-defined event.
      - Note that PetscLogEventRegister() returns to the user a unique
        integer event number, which should then be used for profiling
        the event via PetscLogEventBegin() and PetscLogEventEnd().
      - The user can also optionally log floating point operations
        with the routine PetscLogFlops().
  */
  ierr = PetscLogEventRegister("User event",PETSC_VIEWER_CLASSID,&USER_EVENT);CHKERRQ(ierr);
  ierr = PetscLogEventBegin(USER_EVENT);CHKERRQ(ierr);
  
  int icount = 0;
  for (int i=0; i<imax; i++) icount++;
  ierr = PetscLogFlops(imax);CHKERRQ(ierr);
  ierr = PetscSleep(1);CHKERRQ(ierr);
  ierr = PetscLogEventEnd(USER_EVENT);CHKERRQ(ierr);

  /* 
     We disable the logging of an event.
  */
  ierr = PetscLogEventDeactivate(USER_EVENT);CHKERRQ(ierr);
  ierr = PetscLogEventBegin(USER_EVENT);CHKERRQ(ierr);
  ierr = PetscSleep(1);CHKERRQ(ierr);
  ierr = PetscLogEventEnd(USER_EVENT);CHKERRQ(ierr);

  /* 
     We next enable the logging of an event
  */
  ierr = PetscLogEventActivate(USER_EVENT);CHKERRQ(ierr);
  ierr = PetscLogEventBegin(USER_EVENT);CHKERRQ(ierr);
  ierr = PetscSleep(1);CHKERRQ(ierr);
  ierr = PetscLogEventEnd(USER_EVENT);CHKERRQ(ierr);
  
  PetscFinalize();
  return 0;
}
