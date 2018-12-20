DESTDIR ?= /
PREFIX  ?= /usr/local
OPENSSL_LDFLAGS := $(shell pkg-config --libs-only-L openssl)
OPENSSL_CFLAGS  := $(shell pkg-config --cflags openssl)
CFLAGS += $(OPENSSL_CFLAGS)
LDFLAGS ?= $(LDID_LIBS) $(OPENSSL_LDFLAGS)

.PHONY: all clean
LDID_OBJS = ldid.cpp.o lookup2.c.o
LDID_LIBS = -lplist -lcrypto

all: ldid

%.c.o: %.c
	$(CC) $(CFLAGS) -o $@ -c $^ -I.

%.cpp.o: %.cpp
	$(CXX) $(CFLAGS) $(CXXFLAGS) -std=c++11 -o $@ -c $^ -I.

ldid: $(LDID_OBJS)
	$(CXX) $(CFLAGS) $(CXXFLAGS) $(LDFLAGS) -o $@ $^

clean:
	rm -f $(LDID_OBJS)

install: all
	mkdir -p $(DESTDIR)/$(PREFIX)/bin
	cp ldid $(DESTDIR)/$(PREFIX)/bin
