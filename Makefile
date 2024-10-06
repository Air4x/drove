.POSIX:
.SUFFIX:
HARE=hare
HAREFLAGS=

DESTDIR=
PREFIX=/usr/local
BINDIR=$(PREFIX)/bin

all: cmd

cmd:
	$HARE) build $(HAREFLAGS) -o $@ cmd/$@/

check:
	$(HARE) test $(HAREFLAGS)
clean:
	 rm -f cmd

install:
	install -Dm755 cmd $(DESTDIR)$(BINDIR)/cmd

uninstall:
	rm -f $(DESTDIR)$(BINDIR)/cmd

.PHONY: all check clean install uninstall