SRC_VALA = finder_project.vala Loader.vala main.vala part1.vala part2.vala SupraLeak.vala SupraTest.vala
SRC_C = leak.c
VAPI = Module.vapi
LIB_VALA = --pkg=posix --pkg=gmodule-2.0 --pkg=gio-2.0 -X -lbsd -X -ldl
CFLAGS = --enable-experimental -X -O2 -X -w
NAME = libft_tester 
URL_BOOTSTRAP=https://gitlab.com/hydrasho/libft_tester/uploads/b807fe1db0a242d7a4ffb9a7283b6dad/bootstrap.tar

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

bootstrap.tar:
	wget $(URL_BOOTSTRAP)


bootstrap: bootstrap.tar
	mkdir -p bootstrap
	tar -xf bootstrap.tar -C bootstrap
	$(CC) bootstrap/*.c $$(pkg-config --cflags --libs glib-2.0 gobject-2.0 gio-2.0) -w -lbsd -ldl -o $(NAME)

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

.PHONY: all run run2 re fclean clean bootstrap ninja
