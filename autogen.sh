#!/bin/sh
# autogen.sh - regenerate version, then bootstrap the autotools build system.
set -e

# Compute version from git tags (same scheme as bloom-terminal/build.sh).
# v0.1 -> 0.1, v0.1-5-gabc1234 -> 0.1.5-abc1234, no tags -> 0.0.<count>-<sha>.
if git describe --tags --match 'v*' HEAD >/dev/null 2>&1; then
    git describe --tags --match 'v*' HEAD \
        | sed 's/^v//;s/-\([0-9]*\)-g/.\1-/' > version
else
    count=$(git rev-list --count HEAD 2>/dev/null || echo 0)
    hash=$(git rev-parse --short HEAD 2>/dev/null || echo unknown)
    echo "0.0.${count}-${hash}" > version
fi
echo "Version: $(cat version)"

exec autoreconf -fi "$@"
