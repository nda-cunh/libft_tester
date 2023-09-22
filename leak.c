#define _GNU_SOURCE
#include <stddef.h>
#include <dlfcn.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <pthread.h>
#include <string.h>

// void	ft_putnbr(int nbr)
// {
	// unsigned int	nbr_base;
	// const char	base[] = "0123456789";
// 
	// if (nbr < 0)
	// {
		// nbr = nbr * -1;
		// write(1, "-", 1);
	// }
	// if (nbr >= 10)
	// {
		// ft_putnbr(nbr / 10);
		// write(1, &base[nbr % 10], 1);
	// }
	// else
		// write(1, &base[nbr % 10], 1);
// }

void *(*libc_malloc)(size_t) = NULL;
void (*libc_free)(void*) = NULL;

int malloc_counter;
int free_counter;

void init_malloc() {
	if (libc_malloc == NULL)
		libc_malloc = (void *(*)(size_t))dlsym(RTLD_NEXT, "malloc");
	if (libc_free == NULL)
		libc_free = (void (*)(void *))dlsym(RTLD_NEXT, "free");
	malloc_counter = 0;
	free_counter = 0;
	write(2, "INIT OK\n", 8);
}

int get_free_count(){
	return free_counter;
}

int get_malloc_count(){
	return malloc_counter;
}

void reset_malloc() {
	malloc_counter = 0;
	free_counter = 0;
}

// void show_leak() {
	// write(2, "SHOW: ", 6);
	// write(2, "Malloc: ", 8);
	// ft_putnbr(malloc_counter);
	// write(2, " Free: ", 8);
	// ft_putnbr(free_counter);
	// write(2, "\n", 1);
// }

void* malloc(size_t size)
{
	// write(2, "1 Malloc !\n", 11);
	if (libc_malloc == NULL)
		init_malloc();
    void * p = libc_malloc(size);
	malloc_counter++;
    return (p);
}

void free(void * p)
{
	// write(2, "1 Free!\n", 8);
	if (libc_free == NULL)
		init_malloc();
    libc_free(p);
	free_counter++;
}
