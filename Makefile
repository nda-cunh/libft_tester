SRC = main.vala module.vala part1.vala part2.vala Test.vala
LIB = --pkg=posix --pkg=gmodule-2.0 --pkg=gio-2.0

all:
	valac --enable-experimental -X -lbsd dllloader.vapi leak.c ${SRC} ${LIB} -X -ldl -X -w -X -O2 -o out

run: all 
	export LD_LIBRARY_PATH=./ && ./out

run2:
	export LD_LIBRARY_PATH=./ && ./out
