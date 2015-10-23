PLATFORM ?= $(shell uname -s)
INSTALLPREFIX ?= /usr/local
OPTIMIZE ?= 2
LTO ?= 0

override FLAGS= -O$(OPTIMIZE) -I. -Wall -Wextra -Wno-unused-parameter -Wno-unused-function -Wno-sign-compare
override FLAGS+= -DLDID_NOPLIST

ifeq ($(LTO), 1)
  override FLAGS+= -flto
endif

BIN=ldid

SRCS=\
	ldid.cpp \
	lookup2.c

OBJS=$(subst .cpp,.o,$(SRCS))
OBJS:=$(subst .c,.o,$(OBJS))

LDFLAGS= -lcrypto

all: ldid

%.o: %.cpp
	$(CXX) -std=c++0x $(FLAGS) -c -o $@ $<

%.o: %.c
	$(CC) $(FLAGS) -c -o $@ $<

ldid: $(OBJS)
	$(CXX) $(FLAGS) -o $(BIN) $(OBJS) $(LDFLAGS)

install: ldid
	mkdir -p $(INSTALLPREFIX)/bin
	cp $(BIN) $(INSTALLPREFIX)/bin

.PHONY: clean

clean:
	rm -f $(BIN) $(OBJS)
 
