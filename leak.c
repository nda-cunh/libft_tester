#define _GNU_SOURCE
#include <stddef.h>
#include <stdint.h>
#include <errno.h>
#include <dlfcn.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <pthread.h>
#include <string.h>

void *(*libc_malloc)(size_t) = NULL;
void (*libc_free)(void*) = NULL;
void *(*libc_realloc)(void*, size_t) = NULL;

void* malloc(size_t size);
void* calloc(size_t nmemb, size_t size);
void* realloc(void *ptr, size_t size);
void free(void * p);
extern void* vala_malloc(void* ptr, size_t len);
extern void vala_free(void *ptr);

static char bootstrap_arena[4096];
static size_t bootstrap_used = 0;
static int in_init = 0;

static void *bootstrap_alloc(size_t size)
{
	size = (size + 15) & ~(size_t)15;
	if (size > sizeof(bootstrap_arena) - bootstrap_used)
		return NULL;
	void *p = bootstrap_arena + bootstrap_used;
	bootstrap_used += size;
	return p;
}

static int is_bootstrap(void *p)
{
	return ((char *)p >= bootstrap_arena && (char *)p < bootstrap_arena + sizeof(bootstrap_arena));
}

void init_malloc() {
	in_init = 1;
	libc_malloc = (void *(*)(size_t))dlsym(RTLD_NEXT, "malloc");
	libc_free = (void (*)(void *))dlsym(RTLD_NEXT, "free");
	libc_realloc = (void *(*)(void *, size_t))dlsym(RTLD_NEXT, "realloc");
	in_init = 0;
}

void* malloc(size_t size)
{
	if (libc_malloc == NULL) {
		if (in_init)
			return bootstrap_alloc(size);
		init_malloc();
	}
	if (size > SIZE_MAX - 16) {
		errno = ENOMEM;
		return NULL;
	}
	void* p = libc_malloc(size + 16);
	if (p == NULL)
		return NULL;
	if (vala_malloc(p, size) == NULL) {
		libc_free(p);
		return NULL;
	}
	return (p);
}

void* calloc(size_t nmemb, size_t size)
{
	if (size != 0 && nmemb > SIZE_MAX / size) {
		errno = ENOMEM;
		return NULL;
	}
	void *p = malloc(nmemb * size);
	if (p != NULL && !is_bootstrap(p))
		memset(p, 0, nmemb * size);
	return (p);
}

void* realloc(void *ptr, size_t size)
{
	if (ptr == NULL)
		return malloc(size);
	if (size == 0) {
		free(ptr);
		return NULL;
	}
	if (is_bootstrap(ptr)) {
		void *p = malloc(size);
		size_t max = bootstrap_arena + sizeof(bootstrap_arena) - (char *)ptr;
		if (p != NULL)
			memcpy(p, ptr, size < max ? size : max);
		return (p);
	}
	if (libc_realloc == NULL)
		init_malloc();
	if (size > SIZE_MAX - 16) {
		errno = ENOMEM;
		return NULL;
	}
	return libc_realloc(ptr, size + 16);
}

void free(void * p)
{
	if (p == NULL || is_bootstrap(p))
		return;
	if (libc_free == NULL)
		init_malloc();
	libc_free(p);
	vala_free(p);
}
