#define _GNU_SOURCE
#include <stddef.h>
#include <dlfcn.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <pthread.h>
#include <string.h>

void	ft_putnbr_base(const char *base, long nbr)
{
	unsigned int	nbr_base;

	nbr_base = strlen(base);
	if (nbr < 0)
	{
		nbr = nbr * -1;
		write(1, "-", 1);
	}
	if (nbr >= nbr_base)
	{
		ft_putnbr_base(base, nbr / nbr_base);
		write(1, &base[nbr % nbr_base], 1);
	}
	else
		write(1, &base[nbr % nbr_base], 1);
}

void	ft_putnbr(int nb)
{
	const char	base[] = "0123456789";

	ft_putnbr_base(base, nb);
}


int malloc_counter;
int free_counter;
pthread_mutex_t myMutex;

void init_malloc() {
	malloc_counter = 0;
	free_counter = 0;
	pthread_mutex_init(&myMutex, NULL);
	write(2, "INIT OK\n", 8);
}

void reset_malloc() {
	malloc_counter = 0;
	free_counter = 0;
}

void show_leak() {
	write(2, "SHOW: ", 6);
	write(2, "Malloc: ", 8);
	ft_putnbr(malloc_counter);
	write(2, " Free: ", 8);
	ft_putnbr(free_counter);
	write(2, "\n", 1);
}

void* malloc(size_t size)
{
	pthread_mutex_lock(&myMutex);
	write(2, "1 Malloc !\n", 11);
    void *(*libc_malloc)(size_t) = (void *(*)(size_t))dlsym(RTLD_NEXT, "malloc");
    void * p = libc_malloc(size);
	malloc_counter++;
	pthread_mutex_unlock(&myMutex);
    return (p);
}

void free(void * p)
{
	pthread_mutex_lock(&myMutex);
	write(2, "1 Free!\n", 8);
    void (*libc_free)(void*) = (void (*)(void *))dlsym(RTLD_NEXT, "free");
    libc_free(p);
	free_counter++;
	pthread_mutex_unlock(&myMutex);
}
