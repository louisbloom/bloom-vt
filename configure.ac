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

dnl Recompute the version at configure time so a rebuild after new commits
dnl picks up the current version without needing to re-run autoreconf. Falls
dnl back to PACKAGE_VERSION (set at autoreconf time via m4_esyscmd_s above)
dnl for tarball builds where build-aux/git-version.sh has nothing to read.
BLOOM_VT_VERSION=`"$srcdir/build-aux/git-version.sh" "$srcdir" 2>/dev/null`
AS_IF([test -z "$BLOOM_VT_VERSION"],
      [BLOOM_VT_VERSION="$PACKAGE_VERSION"])
AC_SUBST([BLOOM_VT_VERSION])
AC_MSG_NOTICE([bloom-vt version: $BLOOM_VT_VERSION])

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
