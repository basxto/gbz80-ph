combined-peeph.def: custom-peeph.def peeph-z80.def
	cat $^ > $@

custom-peeph.def: custom/incdec.def
	cat $^ > $@

clean:
	rm -f peeph-z80.def