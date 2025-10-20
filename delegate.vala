//                   _     _ 
//  _ __   __ _ _ __| |_  / |
// | '_ \ / _` | '__| __| | |
// | |_) | (_| | |  | |_  | |
// | .__/ \__,_|_|   \__| |_|
// |_|                       

public int clang_s (int n) {
	if (n == 0)
		return n;
	else if (n > 0)
		return 1;
	return -1;
}

[CCode (has_target = false)]
public delegate int	d_atoi(char *nptr);
[CCode (has_target = false)]
public delegate void d_bzero(void *s, size_t n);
[CCode (has_target = false)]
public delegate void* d_calloc(size_t nmemb, size_t size);
[CCode (has_target = false)]
public delegate int	d_isalnum(int c);
[CCode (has_target = false)]
public delegate int	d_isalpha(int c);
[CCode (has_target = false)]
public delegate int	d_isascii(int c);
[CCode (has_target = false)]
public delegate int	d_isdigit(int c);
[CCode (has_target = false)]
public delegate int	d_isprint(int c);
[CCode (has_target = false)]
public delegate void* d_memchr(void *s, int c, size_t n);
[CCode (has_target = false)]
public delegate int	d_memcmp(void *s1, void *s2, size_t n);
[CCode (has_target = false)]
public delegate void* d_memcpy(void *dest, void *src, size_t n);
[CCode (has_target = false)]
public delegate void* d_memmove(void *dest, void *src, size_t n);
[CCode (has_target = false)]
public delegate void* d_memset(void *s, int c, size_t n);
[CCode (has_target = false)]
public delegate char* d_strchr(char *s, int c);
[CCode (has_target = false)]
public delegate char* d_strdup(char *src);
[CCode (has_target = false)]
public delegate size_t d_strlcat(char *dst, char *src, size_t size);
[CCode (has_target = false)]
public delegate int	d_strncmp(char *s1, char *s2, size_t n);
[CCode (has_target = false)]
public delegate char* d_strnstr(char *big, char *little, size_t len);
[CCode (has_target = false)]
public delegate char* d_strrchr(char *s, int c);
[CCode (has_target = false)]
public delegate int	d_tolower(int c);
[CCode (has_target = false)]
public delegate int	d_toupper(int c);
[CCode (has_target = false)]
public delegate size_t d_strlcpy(char *dst, char *src, size_t size);
[CCode (has_target = false)]
public delegate size_t d_strlen(char *s);




/*****************************************************************
 * Standard C Library functions used
 *
 * used for a better comparaison with the original C libft
 ****************************************************************/

[CCode (cname = "isalpha", cheader_filename="ctype.h")]
public extern int clang_isalpha(int c);
[CCode (cname = "isdigit", cheader_filename="ctype.h")]
public extern int clang_isdigit(int c);
[CCode (cname = "isalnum", cheader_filename="ctype.h")]
public extern int clang_isalnum(int c);
[CCode (cname = "isascii", cheader_filename="ctype.h")]
public extern int clang_isascii(int c);
[CCode (cname = "isprint", cheader_filename="ctype.h")]
public extern int clang_isprint(int c);
[CCode (cname = "memcpy", cheader_filename="string.h")]
public extern void *memcpy(void* dest, void* src, size_t n);
[CCode (cname = "strlcpy", cheader_filename="ctype.h,bsd/string.h")]
public extern size_t strlcpy(char *dest, char *src, size_t size);
[CCode (cname = "strlcat", cheader_filename="ctype.h,bsd/string.h")]
public extern size_t strlcat(char *dest, char *src, size_t size);
[CCode (cname = "toupper", cheader_filename="ctype.h")]
public extern int clang_toupper(int c);
[CCode (cname = "tolower", cheader_filename="ctype.h")]
public extern int clang_tolower(int c);
[CCode (cname = "strchr", cheader_filename="string.h")]
public extern char* strchr(char *s, int c);
[CCode (cname = "strrchr", cheader_filename="string.h")]
public extern char *strrchr(char *s, int c);
[CCode (cname = "strncmp", cheader_filename="string.h")]
public extern int strncmp(char *s1, char* s2, size_t n);
[CCode (cname = "memcmp", cheader_filename="string.h")]
public extern int memcmp(void *s1, void* s2, size_t n);
[CCode (cname = "strnstr", cheader_filename="bsd/string.h")]
public extern unowned string? strnstr(char *s1, char* s2, size_t n);
[CCode (cname = "atoi", cheader_filename="stdlib.h")]
public extern int atoi(string s1);

//                   _     ____  
//  _ __   __ _ _ __| |_  |___ \ 
// | '_ \ / _` | '__| __|   __) |
// | |_) | (_| | |  | |_   / __/ 
// | .__/ \__,_|_|   \__| |_____|
// |_|                           

[CCode (has_target = false)]
public delegate char*	d_substr(char *s, uint start, size_t len);
[CCode (has_target = false)]
public delegate string	d_strjoin(char *s1, char *s2);
[CCode (has_target = false)]
public delegate char*	d_strtrim(char *s1, char *set);
[CCode (has_target = false)]
public delegate string	d_itoa(int n);
[CCode (has_target = false)]
public delegate char	d_param_strmapi(uint n, char c);
[CCode (has_target = false)]
public delegate string	d_strmapi(char *s, d_param_strmapi f);
[CCode (has_target = false)]
public delegate void	d_param_striteri(uint n, char *s);
[CCode (has_target = false)]
public delegate void	d_striteri(char *s, d_param_striteri f);
[CCode (has_target = false)]
public delegate void	d_putchar_fd(char c, int fd);
[CCode (has_target = false)]
public delegate void	d_putendl_fd(char *s, int fd);
[CCode (has_target = false)]
public delegate void	d_putnbr_fd(int n, int fd);
[CCode (has_target = false)]
public delegate void	d_putstr_fd(char *s, int fd);
[CCode (has_target = false)]
public delegate char** d_split(char *s, char c);




//                   _       ___
//  _ __   __ _ _ __| |_    / __\ ___  _ __  _   _ ___
// | '_ \ / _` | '__| __|  /__\/// _ \| '_ \| | | / __|
// | |_) | (_| | |  | |_  / \/  \ (_) | | | | |_| \__ \
// | .__/ \__,_|_|   \__| \_____/\___/|_| |_|\__,_|___/
// |_|


public struct t_list
{
	void *content;
	t_list *next;

	public static t_list* create(void *content) {
		t_list* lst = malloc(sizeof(t_list));
		if (lst == null)
			return null;
		lst.content = content;
		lst.next = null;
		return lst;
	}
	public t_list* get_last_node() {
		t_list *current = &this;
		while (current.next != null) {
			current = current.next;
		}
		return current;
	}
	public t_list append(void *content) {
		t_list *new_node = t_list.create(content);
		t_list *last = this.get_last_node();
		last.next = new_node;
		return this;
	}
	public static void free_list(t_list *head, DelFunction? func = null) {
		t_list *current = head;
		t_list *next_node;
		while (current != null) {
			next_node = current->next;
			if (func != null) {
				func(current->content);
			}
			free(current);
			current = next_node;
		}
	}
	public int get_size() {
		int size = 0;
		t_list *current = &this;
		while (current != null) {
			size++;
			current = current.next;
		}
		return size;
	}
}

[CCode(has_target = false)]
public delegate void*	Function (void *content);
[CCode(has_target = false)]
public delegate void	DelFunction (void *content);

[CCode(has_target = false)]
public delegate t_list *d_lstnew(void *content);
[CCode(has_target = false)]
public delegate int d_lstsize(void *content);
[CCode(has_target = false)]
public delegate void d_lstadd_front(t_list **lst, t_list *new);
[CCode(has_target = false)]
public delegate void d_lstadd_back(t_list **lst, t_list *new);
[CCode(has_target = false)]
public delegate t_list *d_lstlast(t_list *lst);
[CCode(has_target = false)]
public delegate void d_lstdelone(t_list *lst, DelFunction func);
[CCode(has_target = false)]
public delegate void d_lstclear(t_list **lst, DelFunction func);
[CCode(has_target = false)]
public delegate void d_lstiter(t_list *lst, Function func);
[CCode(has_target = false)]
public delegate t_list *d_lstmap(t_list *lst, Function func, DelFunction del);
