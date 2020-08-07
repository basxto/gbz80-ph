combined-peeph.def: custom-peeph.def peeph-z80.def
	cat $^ > $@

custom-peeph.def: custom/incdec.def custom/redundancy.def custom/16bitarithmetic.def custom/ram.def custom/load.def custom/lddi.def custom/jump.def custom/pusharg.def custom/dead.def
	cat $^ > $@

# use this with -Wf--no-peep
internal-peeph.def: special-gbz80.def custom-peeph.def peeph-z80.def
	cat $^ > $@

clean:
	rm -f combined-peeph.def custom-peeph.def internal-peeph.def