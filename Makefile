CC = m68k-atari-mint-gcc
STRIPEX = ~/stripex

CFLAGS += -nostdlib

.PHONY: clean

superfix.prg: superfix.S
	$(CC) $(CFLAGS) -o $@ $?
	$(STRIPEX) $@

clean:
	rm -f superfix.prg