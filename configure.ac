dnl configure.ac - Autoconf configuration for bloom-vt
dnl Process this file with autoreconf -fi to produce a configure script.

AC_PREREQ([2.69])
AC_INIT([bloom-vt],
        m4_esyscmd_s([cat version 2>/dev/null || echo "0.0.0-unknown"]),
        [thomasc1971@hotmail.com],
        [bloom-vt],
        [https://github.com/thomas-christensen/bloom-vt])
AC_CONFIG_SRCDIR([src/term.c])
AC_CONFIG_HEADERS([config.h])
AC_CONFIG_AUX_DIR([build-aux])
AC_CONFIG_MACRO_DIRS([m4])
AC_USE_SYSTEM_EXTENSIONS

AM_INIT_AUTOMAKE([1.14 foreign subdir-objects -Wall -Werror])
AM_SILENT_RULES([yes])

dnl Programs
AC_PROG_CC
AC_PROG_RANLIB
AM_PROG_AR

dnl Headers / types
AC_CHECK_HEADERS([stdlib.h string.h])
AC_TYPE_SIZE_T

dnl Optional: openpty() lives in libutil on Linux/glibc, libc on macOS.
dnl test_bvt_pty links against it; record the result for tests/Makefile.am.
AC_SEARCH_LIBS([openpty], [util], [], [
    AC_MSG_WARN([openpty() not found - test_bvt_pty will not link])
])

AC_CONFIG_FILES([
    Makefile
    src/Makefile
    include/Makefile
    tests/Makefile
    bloom-vt.pc
])

AC_OUTPUT
