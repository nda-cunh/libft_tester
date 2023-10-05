SRC_VALA = finder_project.vala Loader.vala main.vala part1.vala part2.vala SupraLeak.vala SupraTest.vala
SRC_C = leak.c
VAPI = Module.vapi
LIB_VALA = --pkg=posix --pkg=gmodule-2.0 --pkg=gio-2.0 -X -lbsd -X -ldl
CFLAGS = --enable-experimental -X -O2 -X -w
NAME = libft_tester 

# Color
GREEN = \033[32;1m
WHITE= \033[37;1m
YELLOW = \033[33;1m
NC = \033[0m

all: $(NAME)

# Makefile version
libft_tester: 
	valac $(SRC_VALA) $(SRC_C) $(LIB_VALA) $(CFLAGS) $(VAPI) -o $(NAME)

# Meson version
libft_tester_dev: build/build.ninja ninja 

build/build.ninja:
	meson build --prefix=$(PWD) --bindir=. --optimization=3

ninja:
	ninja install -C build
# END 


clean:
	rm -rf $(SRC_VALA:.vala=.c)
	rm -rf $(OBJ)

fclean: clean
	rm -rf build/
	rm -rf libft_tester
	rm -rf libft_tester_dev

re: fclean all

run: all
	./$(NAME)

run2:
	./$(NAME)
