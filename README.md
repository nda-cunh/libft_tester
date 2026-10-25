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

# NOTES

If you see some 'EEEEEEE', it's because the libft_tester fills the stack and the heap with 'E' before running your tests.

`[🛡️ ]` means your function survives NULL arguments, `[  ]` means it crashes on them.
NULL is undefined for the non-libc functions (part 2 and 3), so both are fine.

# SupraTester

It loads your functions and tests them
asynchronously and fast on several processors.

It checks the memory with SupraLeak to stay fast :)

An idea? Something else? Open an issue!
