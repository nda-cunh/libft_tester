The SupraTester for the 42 school libft (Linux ~~Mac Os~~)

# INSTALLATION

	clone the repo inside your libft or at its root.
	run './install.sh' to compile and install the libft_tester
	the `libft_tester` file has been created
	run it with `./libft_tester`

# REQUIREMENTS
	``vala``
	``a C compiler (clang or gcc)``
	``meson and ninja``

# VERSUS MODE

Benchmark your libft against the libc or against another libft:

	./libft_tester --versus libc               # your libft vs the glibc (+ libbsd for strlcpy/strlcat/strnstr)
	./libft_tester --versus ../other_libft     # a folder with a Makefile, it gets compiled
	./libft_tester --versus other/libft.a      # a static archive
	./libft_tester --versus other/libft.so     # a shared library

15 rounds are played: `strlen`, `memcpy`, `memset`, `bzero`, `memmove`, `memchr`, `memcmp`,
`strchr`, `strrchr`, `strncmp`, `strlcpy`, `strlcat`, `strnstr`, `strdup` and `atoi`.

Each round runs on 4 sizes: `light` (32 bytes), `medium` (4 KB), `max` (1 MB) and `max+1`
(1 MB on an unaligned address). `atoi` uses `short`, `int_min` and `spaces` inputs instead.

- The best of 5 runs is kept for each side, and the fork cost is removed from the time.
- A size is won when one side is more than 5% faster; the round goes to whoever wins the most sizes.
- A missing function means a **FORFEIT**: the opponent wins the round.
- A **K.O.** means you lost a round by a huge gap (x50 against the libc, x5 against another libft).

The recap shows the ratio for every function (`×N` = N times slower, `▲×N` = N times faster),
the final score and the mean gap. Against the libc you also get a level, from `beginner` to `GLIBC KILLER`.

# NOTES

If you see some 'EEEEEEE', it's because the libft_tester fills the stack and the heap with 'E' before running your tests.

`[🛡️ ]` means your function survives NULL arguments, `[  ]` means it crashes on them.
NULL is undefined for the non-libc functions (part 2 and 3), so both are fine.

# SupraTester

It loads your functions and tests them
asynchronously and fast on several processors.

It checks the memory with SupraLeak to stay fast :)

An idea? Something else? Open an issue!
