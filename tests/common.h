#ifndef COMMON_H
#define COMMON_H

#include <stdarg.h>

extern int verbose;

void vlog_impl(const char *file, const char *func, int line, const char *format, ...);

#define vlog(fmt, ...) vlog_impl(__FILE__, __func__, __LINE__, fmt, ##__VA_ARGS__)

#endif
