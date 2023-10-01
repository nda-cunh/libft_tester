SRC_VALA = main.vala module.vala part1.vala part2.vala Test.vala supraleak.vala
LIB_VALA = --pkg=posix --pkg=gmodule-2.0 --pkg=gio-2.0
LIB = $$(pkg-config --libs gmodule-2.0 gio-2.0) -lbsd -ldl
CFLAGS = $$(pkg-config --cflags gmodule-2.0 gio-2.0) -O2
SRC_C = $(SRC_VALA:.vala=.c) leak.c 
OBJ = $(SRC_C:.c=.o) 
NAME = test 

all: $(NAME)

$(NAME) : $(OBJ)
	gcc $(OBJ) $(LIB) -o $(NAME)

%.o : %.c
	gcc $(CFLAGS) $< -c -o $@

${SRC_C}:
	valac --enable-experimental dllloader.vapi leak.c ${SRC_VALA} ${LIB_VALA} -C

clean:
	rm -rf $(SRC_VALA:.vala=.c)
	rm -rf $(OBJ)

fclean: clean
	rm -rf $(NAME)
	

run: all 
	export LD_LIBRARY_PATH=./ && ./$(NAME)

run2:
	export LD_LIBRARY_PATH=./ && ./$(NAME)
