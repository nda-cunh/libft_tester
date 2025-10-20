// delegate int d_isalpha(int c);

[CCode (has_target = false)]
delegate int	d_atoi(char *nptr);
[CCode (has_target = false)]
delegate void	d_bzero(void *s, size_t n);
[CCode (has_target = false)]
delegate void*	d_calloc(size_t nmemb, size_t size);
[CCode (has_target = false)]
delegate int	d_isalnum(int c);
[CCode (has_target = false)]
delegate int	d_isalpha(int c);
[CCode (has_target = false)]
delegate int	d_isascii(int c);
[CCode (has_target = false)]
delegate int	d_isdigit(int c);
[CCode (has_target = false)]
delegate int	d_isprint(int c);
[CCode (has_target = false)]
delegate void*	d_memchr(void *s, int c, size_t n);
[CCode (has_target = false)]
delegate int	d_memcmp(void *s1, void *s2, size_t n);
[CCode (has_target = false)]
delegate void*	d_memcpy(void *dest, void *src, size_t n);
[CCode (has_target = false)]
delegate void*	d_memmove(void *dest, void *src, size_t n);
[CCode (has_target = false)]
delegate void*	d_memset(void *s, int c, size_t n);
[CCode (has_target = false)]
delegate char*	d_strchr(char *s, int c);
[CCode (has_target = false)]
delegate char*	d_strdup(char *src);
[CCode (has_target = false)]
delegate size_t	d_strlcat(char *dst, char *src, size_t size);
[CCode (has_target = false)]
delegate int	d_strncmp(char *s1, char *s2, size_t n);
[CCode (has_target = false)]
delegate char*	d_strnstr(char *big, char *little, size_t len);
[CCode (has_target = false)]
delegate char*	d_strrchr(char *s, int c);
[CCode (has_target = false)]
delegate int	d_tolower(int c);
[CCode (has_target = false)]
delegate int	d_toupper(int c);
[CCode (has_target = false)]
delegate size_t	d_strlcpy(char *dst, char *src, size_t size);
[CCode (has_target = false)]
delegate size_t	d_strlen(char *s);

public int clang_s (int n) {
	if (n == 0)
		return n;
	else if (n > 0)
		return 1;
	return -1;
}

[CCode (cname = "isalpha", cheader_filename="ctype.h")]
extern int clang_isalpha(int c);

[CCode (cname = "isdigit", cheader_filename="ctype.h")]
extern int clang_isdigit(int c);

[CCode (cname = "isalnum", cheader_filename="ctype.h")]
extern int clang_isalnum(int c);

[CCode (cname = "isascii", cheader_filename="ctype.h")]
extern int clang_isascii(int c);

[CCode (cname = "isprint", cheader_filename="ctype.h")]
extern int clang_isprint(int c);

[CCode (cname = "memcpy", cheader_filename="string.h")]
extern void *memcpy(void* dest, void* src, size_t n);

[CCode (cname = "strlcpy", cheader_filename="ctype.h,bsd/string.h")]
extern size_t strlcpy(char *dest, char *src, size_t size);

[CCode (cname = "strlcat", cheader_filename="ctype.h,bsd/string.h")]
extern size_t strlcat(char *dest, char *src, size_t size);

[CCode (cname = "toupper", cheader_filename="ctype.h")]
extern int clang_toupper(int c);

[CCode (cname = "tolower", cheader_filename="ctype.h")]
extern int clang_tolower(int c);

[CCode (cname = "strchr", cheader_filename="string.h")]
extern char* strchr(char *s, int c);

[CCode (cname = "strrchr", cheader_filename="string.h")]
extern char *strrchr(char *s, int c);

[CCode (cname = "strncmp", cheader_filename="string.h")]
extern int strncmp(char *s1, char* s2, size_t n);

[CCode (cname = "memcmp", cheader_filename="string.h")]
extern int memcmp(void *s1, void* s2, size_t n);

[CCode (cname = "strnstr", cheader_filename="bsd/string.h")]
extern unowned string? strnstr(char *s1, char* s2, size_t n);

[CCode (cname = "atoi", cheader_filename="stdlib.h")]
extern int atoi(string s1);
