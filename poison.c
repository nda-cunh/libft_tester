#include <string.h>

__attribute__((noinline))
void poison_stack(void)
{
	unsigned char memory[8192];

	memset(memory, 'E', sizeof(memory) / 2);
	memset(memory + sizeof(memory) / 2, '\0', sizeof(memory) / 2);
	__asm__ volatile ("" : : "r"(memory) : "memory");
}
