#define _GNU_SOURCE
#include <stddef.h>
#include <dlfcn.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <pthread.h>
#include <string.h>

// Delegate
void *(*libc_malloc)(size_t) = NULL;
void (*libc_free)(void*) = NULL;

// Prototype
void* malloc(size_t size);
void free(void * p);
extern void* vala_malloc(void* ptr, size_t len);
extern void vala_free(void *ptr);

void init_malloc() {
	libc_malloc = (void *(*)(size_t))dlsym(RTLD_NEXT, "malloc");
	libc_free = (void (*)(void *))dlsym(RTLD_NEXT, "free");
}

void* malloc(size_t size)
{
	if (libc_malloc == NULL)
		init_malloc();
	void* p = libc_malloc(size + 16);
	if (vala_malloc(p, size) == NULL) {
		libc_free(p);
		return NULL;
	}
	return (p);
}

void free(void * p)
{
	if (libc_free == NULL)
		init_malloc();
	libc_free(p);
	vala_free(p);
}
