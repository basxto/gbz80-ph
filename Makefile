combined-peeph.def: custom-peeph.def peeph-z80.def
	cat $^ > $@

custom-peeph.def: custom/incdec.def custom/redundancy.def custom/16bitarithmetic.def custom/ram.def custom/load.def
	cat $^ > $@

clean:
	rm -f peeph-z80.def