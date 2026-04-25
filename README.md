# bloom-vt

A standalone virtual terminal engine in C — parser, grid, scrollback, reflow,
charsets, kitty keyboard protocol — with no external dependencies. Extracted
from [bloom-terminal](https://github.com/thomas-christensen/bloom-terminal),
where it replaces libvterm.

## What it does

- **VT100 / VT220 / xterm parser** — CSI / OSC / DCS / ESC dispatch, DEC
  modes, scrolling regions, charsets (incl. DEC special graphics line
  drawing), origin mode, tab-stop manipulation (TBC).
- **UAX-aware grid** — Unicode #11 East Asian Width and #29 grapheme
  cluster widths computed at insertion time and stored on each cell.
  ZWJ sequences, regional indicators, skin-tone modifiers, and VS16
  emoji presentation all carry the right cell width without
  per-renderer peek-ahead.
- **Grapheme arena** — full clusters are interned; cells reference them
  by id, so there is no hardcoded codepoint cap (libvterm caps at 6).
- **Scrollback** — paged ring buffer; default 1000 lines, configurable.
- **Reflow** — recomputes wrap on resize; preserves cursor row.
- **Kitty keyboard protocol** — flags 0x1 (Disambiguate) and 0x8 (Report
  all keys as escape codes) are fully implemented. Push/pop/set/query
  of the flag stack works. Flags 0x2/0x4/0x10 are accepted on the stack
  but currently no-ops (waiting on a concrete consumer).
- **Zero external dependencies** — libc only.

For the project status — what is byte-identical to libvterm, accepted
divergences, and the deferred items — see [`FOLLOWUPS.md`](FOLLOWUPS.md).

## Build and install

Standard GNU autotools workflow:

```sh
./autogen.sh                                # writes ./version, runs autoreconf -fi
./configure --prefix=$HOME/.local
make
make check
make install
```

Optional targets:

```sh
make format       # clang-format on src/, include/, tests/; prettier on *.md
make bear         # produce compile_commands.json for clangd
make distcheck    # build, test, and verify the dist tarball is self-contained
```

## Linking

```sh
cc app.c $(pkg-config --cflags --libs bloom-vt)
```

`bloom-vt.pc` installs to `${libdir}/pkgconfig/`.

## Minimal usage

```c
#include <bloom-vt/bloom_vt.h>
#include <stdio.h>

int main(void)
{
    BvtTerm *vt = bvt_new(24, 80);  /* 24 rows x 80 cols */

    const char *bytes = "hello\033[31m world\033[0m\n";
    bvt_input_write(vt, (const uint8_t *)bytes, strlen(bytes));

    int rows, cols;
    bvt_get_dimensions(vt, &rows, &cols);
    for (int c = 0; c < cols; c++) {
        const BvtCell *cell = bvt_get_cell(vt, 0, c);
        if (!cell || cell->width == 0) continue;
        putchar(cell->cp ? (int)cell->cp : ' ');
    }
    putchar('\n');

    bvt_free(vt);
    return 0;
}
```

The full API is in [`include/bloom-vt/bloom_vt.h`](include/bloom-vt/bloom_vt.h).

## License

MIT. See [`COPYING`](COPYING).
