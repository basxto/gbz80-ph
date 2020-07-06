Build
=====
```shell
$ make combined-peeph.def internal-peeph.def
```

Use
===
Attach the following flag when you call `lcc`:
```bash
-Wf"--peep-file/absolute/path/to/gbz80-ph/combined-peeph.def"
```
If you want to replace the internal peep hole rules use:
```bash
-Wf--no-peep -Wf"--peep-file/absolute/path/to/gbz80-ph/internal-peeph.def"
```

Debug
=====

Use `-Wf--fverbose-asm` for adding debug comments into generated assembly:

```makefile
LCC?=lcc -v -Wa-l
CC=$(LCC) -c $(CFLAGS)
CA=$(LCC) -c

%.rel: %.s
	$(CA) -o $@ $^

%.s: %.c
	$(CC) -Wf--fverbose-asm -S -o $@ $^

```

You will get comments like this:
```asm
; incdec peephole 1 moved decrement of hl to constant
	ld	hl, #_sg + 0
;fetchLitPair
	ld	a, (hl+)
; gbz80 peephole 2b used ldi to increment hl after load
;	genPlus
;fetchPairLong
;fetchLitPair
; 16bitarithmetic peephole 3 improved 8bit and 16bit addition
; z80 peephole 9 loaded a from a directly instead of going through c.
; z80 peephole 0 removed redundant load from a into a.
	add	a, #0x41
	ld	c, a
	adc	a, (hl)
	sub	a, c
	ld	b, a
```

`incdec peephole 1` is rule 1 of `custom/incdec.def`

`gbz80 peephole 2b` is rule 2b of `peeph-gbz80.def`

`16bitarithmetic peephole 3` is rule 3 of `custom/16bitarithmetic.def`

`z80 peephole 9` is rule 9 of `peeph-z80.def`

and so on.

For testing you can remove .def-files from the `Makefile` or comment out single rules with `\\` and a multiline cursor.

Master
======
`develop` branch should only be merged into `master` if it passes all regression tests of sdcc for gbz80.
```bash
SDCCCODEDIR=/path/to/sdcc-code
PROCESSES=8
make internal-peeph.def
# back up original rules
cp ${SDCCCODEDIR}/sdcc/src/z80/peeph-gbz80.def ${SDCCCODEDIR}/sdcc/src/z80/peeph-gbz80.bak.def
cp ${SDCCCODEDIR}/sdcc/src/z80/peeph.def ${SDCCCODEDIR}/sdcc/src/z80/peeph.bak.def
# delete common rules
echo "" > ${SDCCCODEDIR}/sdcc/src/z80/peeph.def
# copy generated rules
cp internal-peeph.def ${SDCCCODEDIR}/sdcc/src/z80/peeph-gbz80.def
# build sdcc
cd ${SDCCCODEDIR}/sdcc/
make -j${PROCESSES}
# run regression tests
cd ${SDCCCODEDIR}/sdcc/support/regression
make clean
make test-ucgbz80 -j${PROCESSES}
```