.POSIX:
.SUFFIX:
HARE=hare
HAREFLAGS=

DESTDIR=
PREFIX=/usr/local
BINDIR=$(PREFIX)/bin

all: cmd

cmd:
	$(HARE) build $(HAREFLAGS) -o drove cmd/drove/main.ha

check:
	$(HARE) test $(HAREFLAGS)
clean:
	 rm -f drove

install:
	install -Dm755 drove $(DESTDIR)$(BINDIR)/drove

uninstall:
	rm -f $(DESTDIR)$(BINDIR)/drove

.PHONY: all check clean install uninstall
