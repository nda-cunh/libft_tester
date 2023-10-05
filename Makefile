SRC_VALA = main.vala module.vala part1.vala part2.vala SupraLeak.vala SupraTest.vala finder_project.vala
LIB_VALA = --pkg=posix --pkg=gmodule-2.0 --pkg=gio-2.0
LIB = $$(pkg-config --libs gmodule-2.0 gio-2.0) -lbsd -ldl
CFLAGS = $$(pkg-config --cflags gmodule-2.0 gio-2.0) -O2 -w
SRC_C = $(SRC_VALA:.vala=.c) leak.c
OBJ = $(SRC_C:.c=.o)
NAME = test

# Color
GREEN = \033[32;1m
WHITE= \033[37;1m
YELLOW = \033[33;1m
NC = \033[0m


all: $(NAME)

$(NAME) : $(OBJ)
	@gcc $(OBJ) $(LIB) -o $(NAME)
	@printf "$(YELLOW)[ LINKING ]$(NC)\n"

%.o : %.c 
	@gcc $(CFLAGS) $< -c -o $@
	@printf "$(WHITE)compiling $< >>> $@$(NC)\n"

$(SRC_VALA:.vala=.c): $(SRC_VALA)
	@! [ -f $@ ] \
		&& valac --disable-warnings --enable-experimental dllloader.vapi $(SRC_VALA) $(LIB_VALA) -C \
		&& printf "$(GREEN)[ Generation of all C Files ]$(NC)\n"

clean:
	rm -rf $(SRC_VALA:.vala=.c)
	rm -rf $(OBJ)

fclean: clean
	rm -rf $(NAME)

re: fclean all

run: all
	export LD_LIBRARY_PATH=./ && ./$(NAME)

run2:
	export LD_LIBRARY_PATH=./ && ./$(NAME)
