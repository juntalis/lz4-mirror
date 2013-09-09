# ################################################################
# LZ4 Makefile
# Copyright (C) Yann Collet 2011-2013
# GPL v2 License
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
#
# You can contact the author at :
#  - LZ4 source repository : http://code.google.com/p/lz4/
# ################################################################
# lz4 : Command Line Utility, supporting gzip-like arguments
# lz4c  : CLU, supporting also legacy lz4demo arguments
# lz4c32: Same as lz4c, but forced to compile in 32-bits mode
# fuzzer  : Test tool, to check lz4 integrity on target platform
# fuzzer32: Same as fuzzer, but forced to compile in 32-bits mode
# fullbench  : Precisely measure speed for each LZ4 function variant
# fullbench32: Same as fullbench, but forced to compile in 32-bits mode
# ################################################################

CC=gcc
CFLAGS=-I. -std=c99 -Wall -W -Wundef -Wno-implicit-function-declaration

# Define *.exe as extension for Windows systems
OS := $(shell uname)
ifeq ($(OS),Linux)
EXT =
else
EXT =.exe
endif

default: lz4c

all: lz4 lz4c lz4c32 fuzzer fuzzer32 fullbench fullbench32

lz4: lz4.c lz4hc.c bench.c xxhash.c lz4cli.c
	$(CC)      -O3 $(CFLAGS) -DDISABLE_LZ4C_LEGACY_OPTIONS $^ -o $@$(EXT)

lz4c: lz4.c lz4hc.c bench.c xxhash.c lz4cli.c
	$(CC)      -O3 $(CFLAGS) $^ -o $@$(EXT)

lz4c32: lz4.c lz4hc.c bench.c xxhash.c lz4cli.c
	$(CC) -m32 -O3 $(CFLAGS) $^ -o $@$(EXT)

fuzzer : lz4.c lz4hc.c fuzzer.c
	@echo fuzzer is a test tool to check lz4 integrity on target platform
	$(CC)      -O3 $(CFLAGS) $^ -o $@$(EXT)

fuzzer32 : lz4.c lz4hc.c fuzzer.c
	$(CC) -m32 -O3 $(CFLAGS) $^ -o $@$(EXT)

fullbench : lz4.c lz4hc.c xxhash.c fullbench.c
	$(CC)      -O3 $(CFLAGS) $^ -o $@$(EXT)

fullbench32 : lz4.c lz4hc.c xxhash.c fullbench.c
	$(CC) -m32 -O3 $(CFLAGS) $^ -o $@$(EXT)

clean:
	rm -f core *.o lz4$(EXT) lz4c$(EXT) lz4c32$(EXT) fuzzer$(EXT) fuzzer32$(EXT) fullbench$(EXT) fullbench32$(EXT)
