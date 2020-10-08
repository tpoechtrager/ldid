INSTALLPREFIX  ?= /usr/local

INCLUDES += -isystem libplist/src
INCLUDES += -isystem libplist/libcnary/include
INCLUDES += -isystem libplist/include

CFLAGS += -O2 -fPIC
CFLAGS += $(INCLUDES)
CFLAGS += -Wall
CFLAGS += -Wno-strict-aliasing

CXXFLAGS += -O2 -fPIC
CXXFLAGS += $(INCLUDES)
CXXFLAGS += -Wall
CXXFLAGS += -Wno-sign-compare
CXXFLAGS += -Wno-deprecated-declarations
CXXFLAGS += -Wno-unused-function

LDID_OBJS += libplist/libcnary/node.o
LDID_OBJS += libplist/libcnary/node_list.o
LDID_OBJS += libplist/src/base64.o
LDID_OBJS += libplist/src/time64.o
LDID_OBJS += libplist/src/bytearray.o
LDID_OBJS += libplist/src/ptrarray.o
LDID_OBJS += libplist/src/bplist.o
LDID_OBJS += libplist/src/plist.o
LDID_OBJS += libplist/src/xplist.o
LDID_OBJS += libplist/src/hashtable.o
LDID_OBJS += ldid.cpp.o lookup2.c.o

LDFLAGS = -lcrypto -pthread

.PHONY: all clean

all: ldid

%.c.o: %.c
	$(CC) $(CFLAGS) -o $@ -c $^ -I.

%.cpp.o: %.cpp
	$(CXX) $(CXXFLAGS) -std=c++0x -o $@ -c $^ -I.

ldid: $(LDID_OBJS)
	$(CXX) $(CFLAGS) $(CXXFLAGS) -o $@ $^ $(LDFLAGS)

clean:
	rm -f $(LDID_OBJS)

install: all
	mkdir -p $(INSTALLPREFIX)/bin
	cp ldid $(INSTALLPREFIX)/bin
