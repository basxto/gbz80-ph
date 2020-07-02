combined-peeph.def: peeph-z80.def
	cat $^ > $@

clean:
	rm -f peeph-z80.def