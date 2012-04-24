#############################################################
#
#
#
#############################################################
#
# Process this file with autoconf to produce a configure script.
#
# Changelog:
# 
#

AC_PREREQ(2.59)
AC_INIT(hpcd, 0.01, bd512@york.ac.uk)

#############################################################
# MPI C compiler
#############################################################

AC_SUBST(MPICC)

AC_CHECK_PROGS(MPICC, mpicc cc, $CC)

#############################################################
# D compiler
#############################################################

AC_SUBST(DC)

AC_CHECK_PROGS(DC, dmd gdc, $DC)


# Check libraries needed to link D objects using MPICC

#############################################################
# Write to config file
#############################################################

AC_OUTPUT(make.config)
