[CCode (has_target = false)]
delegate char*	d_substr(char *s, uint start, size_t len);
[CCode (has_target = false)]
delegate string	d_strjoin(char *s1, char *s2);
[CCode (has_target = false)]
delegate char*	d_strtrim(char *s1, char *set);
[CCode (has_target = false)]
delegate string	d_itoa(int n);
[CCode (has_target = false)]
delegate char	d_param_strmapi(uint n, char c);
[CCode (has_target = false)]
delegate string	d_strmapi(char *s, d_param_strmapi f);
[CCode (has_target = false)]
delegate void	d_param_striteri(uint n, char *s);
[CCode (has_target = false)]
delegate void	d_striteri(char *s, d_param_striteri f);
[CCode (has_target = false)]
delegate void	d_putchar_fd(char c, int fd);
[CCode (has_target = false)]
delegate void	d_putendl_fd(char *s, int fd);
[CCode (has_target = false)]
delegate void	d_putnbr_fd(int n, int fd);
[CCode (has_target = false)]
delegate void	d_putstr_fd(char *s, int fd);
[CCode (has_target = false)]
delegate char** d_split(char *s, char c);
