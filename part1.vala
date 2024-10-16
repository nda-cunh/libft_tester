// delegate int d_isalpha(int c);

delegate int	d_atoi(char *nptr);
delegate void	d_bzero(void *s, size_t n);
delegate void*	d_calloc(size_t nmemb, size_t size);
delegate int	d_isalnum(int c);
delegate int	d_isalpha(int c);
delegate int	d_isascii(int c);
delegate int	d_isdigit(int c);
delegate int	d_isprint(int c);
delegate void*	d_memchr(void *s, int c, size_t n);
delegate int	d_memcmp(void *s1, void *s2, size_t n);
delegate void*	d_memcpy(void *dest, void *src, size_t n);
delegate void*	d_memmove(void *dest, void *src, size_t n);
delegate void*	d_memset(void *s, int c, size_t n);
delegate char*	d_strchr(char *s, int c);
delegate char*	d_strdup(char *src);
delegate size_t	d_strlcat(char *dst, char *src, size_t size);
delegate int	d_strncmp(char *s1, char *s2, size_t n);
delegate char*	d_strnstr(char *big, char *little, size_t len);
delegate char*	d_strrchr(char *s, int c);
delegate int	d_tolower(int c);
delegate int	d_toupper(int c);
delegate size_t	d_strlcpy(char *dst, char *src, size_t size);
delegate size_t	d_strlen(char *s);

int clang_s (int n) {
	if (n == 0)
		return n;
	else if (n > 0)
		return 1;
	return -1;
}

[CCode (cname = "isalpha", cheader_filename="ctype.h")]
extern int clang_isalpha(int c);

string run_isalpha() {
	string result = "IS_ALPHA: ";
	try {
		var ft_isalpha= (d_isalpha)loader.symbol("ft_isalpha");
		var t = SupraTest.test(null, () => {
			for (int i = 0; i < 255; ++i)
			{
				if (clang_s(ft_isalpha(i)) != clang_s(clang_isalpha(i))) {
					stderr.printf("input: [%d] You: %d, Me: %d ", i, ft_isalpha(i), clang_isalpha(i));
					return false;
				}
			}
			return true;
		});
		return result + t.msg_err();
	}
	catch (Error e) {
		return @"$result \033[31m$(e.message)\033[0m";
	}
}

[CCode (cname = "isdigit", cheader_filename="ctype.h")]
extern int clang_isdigit(int c);

string run_isdigit() {
	string result = "ISDIGIT:  ";
	try {
		var ft_isdigit= (d_isdigit)loader.symbol("ft_isdigit");
		var t = SupraTest.test(null, () => {
				for (int i = 0; i < 255; ++i)
				{
					if (clang_s(ft_isdigit(i)) != clang_s(clang_isdigit(i))) {
						stderr.printf("input: [%d] You: %d, Me: %d ", i, ft_isdigit(i), clang_isdigit(i));
						return false;
					}
				}
				return true;
			});
		return result + t.msg_err();
	}
	catch (Error e) {
		return @"$result \033[31m$(e.message)\033[0m";
	}
}

[CCode (cname = "isalnum", cheader_filename="ctype.h")]
extern int clang_isalnum(int c);

string run_isalnum() {
	string result = "ISALNUM:  ";
	try {
		var ft_isalnum= (d_isalnum)loader.symbol("ft_isalnum");
		var t = SupraTest.test(null, () => {
			for (int i = 0; i < 255; ++i)
			{
				if (clang_s(ft_isalnum(i)) != clang_s(clang_isalnum(i))) {
					stderr.printf("input: [%d] You: %d, Me: %d ", i, ft_isalnum(i), clang_isalnum(i));
					return false;
				}
			}
			return true;
		});
		return result + t.msg();
	}
	catch (Error e) {
		return @"$result \033[31m$(e.message)\033[0m";
	}
}

[CCode (cname = "isascii", cheader_filename="ctype.h")]
extern int clang_isascii(int c);

string run_isascii() {
	string result = "ISASCII:  ";
	try {
		var ft_isascii= (d_isascii)loader.symbol("ft_isascii");
		var t = SupraTest.test(null, () => {
				for (int i = 0; i < 255; ++i)
				{
					if (clang_s(ft_isascii(i)) != clang_s(clang_isascii(i))) {
						stderr.printf("%d", i);
						return false;
					}
				}
				return true;
			});
		return result + t.msg_err("Bad Input:");
	}
	catch (Error e) {
		return @"$result \033[31m$(e.message)\033[0m";
	}
}

[CCode (cname = "isprint", cheader_filename="ctype.h")]
extern int clang_isprint(int c);

string run_isprint() {
	string result = "ISPRINT:  ";
	try {
		var ft_isprint= (d_isprint)loader.symbol("ft_isprint");
		var t = SupraTest.test(null, () => {
				for (int i = 0; i < 255; ++i)
				{
					if (clang_s(ft_isprint(i)) != clang_s(clang_isprint(i))) {
						stderr.printf("%d", i);
						return false;
					}
				}
				return true;
			});
		return result + t.msg_err("Input: ");
	}
	catch (Error e) {
		return @"$result \033[31m$(e.message)\033[0m";
	}
}


string run_strlen() {
	var result = "STRLEN:   ";
	try {
		var ft_strlen = (d_strlen)loader.symbol("ft_strlen");
		/* 1 */ result += (SupraTest.test(null, () => { return (ft_strlen("1") == 1); }, "1").msg());
		/* 2 */ result += (SupraTest.test(null, () => { return (ft_strlen("12") == 2); }, "2").msg());
		/* 3 */ result += (SupraTest.test(null, () => { return (ft_strlen("123") == 3); }, "3").msg());
		/* 4 */ result += (SupraTest.test(null, () => { return (ft_strlen("1234") == 4); }, "4").msg());
		/* 5 */ result += (SupraTest.test(null, () => { return (ft_strlen("12345") == 5); }, "5").msg());
		/* 6 */ result += (SupraTest.test(null, () => { return (ft_strlen("   \t\t\t\r\n") == 8); }, "8 spaces").msg());
		/* 6 */ result += (SupraTest.test(null, () => { return (ft_strlen("abcdefghijklmnopqrdtuvwxyz") == 26); }, "abcdefghijklmnopqrdtuvwxyz").msg());
		/* 7 */
		result += (SupraTest.test(null, () => {
			ft_strlen(null);
			return false;
		}, "No segfault with strlen(null)").msg_need_segfault());
		return result;
	}
	catch (Error e) {
		return @"$(result) \033[31m$(e.message)\033[0m";
	}
}


string run_memset() {
	string result = "MEMSET:   ";
	try {
		var ft_memset = (d_memset)loader.symbol("ft_memset");
		result += SupraTest.test(null, () => {
			uint8 buf[20];
			ft_memset(buf, 'E', 6);
			buf[6] = '\0';
			return((string)buf == "EEEEEE");
		}, "memset(mem, E, 6)").msg();

		result += SupraTest.test(null, () => {
			uint8 buf[20];
			ft_memset(buf, 'E', 6);
			buf[6] = '\0';
			return(buf[7] != 'E');
		}, "trop loin... ft_memset(buf, 'E', 6)").msg();

		result += SupraTest.test(null, () => {
			uint8 buf[20];
			buf[5] = '\0';
			ft_memset(buf, 'E', 6);
			buf[6] = '\0';
			return(buf[5] == 'E');
		}, "pas assez loin... ft_memset(buf, 'E', 6").msg();

		result += SupraTest.test(null, () => {
			uint8 buf[5];
			buf[0] = 'J';
			ft_memset(buf, 'E', 0);
			return(buf[0] == 'J');
		}, "ft_memset(buf, 'E', 0)").msg();

		result += SupraTest.test(null, () => {
			ft_memset(null, 0, 0);
			return true;
		}, """ft_memset(NULL, 0, 0)""").msg();

		result += SupraTest.test(null, () => {
			ft_memset(null, 0, 1);
			return true;
		}, "No segfault with memset(null, 0, 1)").msg_need_segfault();


		return result;
	}
	catch (Error e) {
		return @"$result \033[31m$(e.message)\033[0m";
	}
}


string run_bzero() {
	var result = new StringBuilder.sized(300);
	result.append("BZERO:    ");
	try {
		var ft_bzero = (d_bzero)loader.symbol("ft_bzero");
		for (int i = 0; i < 25; ++i)
		{
			result.append(SupraTest.test(null, () => {
				uint8 buf1[128];
				uint8 buf2[128];
				Memory.set(buf1, 'X', 40);
				Memory.set(buf2, 'X', 40);

				ft_bzero(buf1, i);
				Memory.set(buf2, '\0', i);
				if (Memory.cmp(buf1, buf2, 38) == 0)
					return true;
				return false;
			}, @"bzero(mem, E, $i)").msg());
		}
		return (owned)result.str;
	}
	catch (Error e) {
		return @"$(result.str) \033[31m$(e.message)\033[0m";
	}
}

// MEMCPY
[CCode (cname = "memcpy", cheader_filename="string.h")]
extern void *memcpy(void* dest, void* src, size_t n);

string run_memcpy() {
	string result = "MEMCPY:   ";
	try {
		var ft_memcpy = (d_memcpy)loader.symbol("ft_memcpy");

		result += SupraTest.test(null, () => {
			const string dest1 = "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
			const string dest2 = "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
			var r = ft_memcpy(dest1, "coucou", 0);
			Memory.copy(dest2, "coucou", 0);
			if (r != dest1) {
				stderr.printf("Return is not 'dest' ");
				return false;
			}
			if (Memory.cmp(dest1.data, dest2.data, 30) != 0) {
				stderr.printf("Memory is not 'AAAAAAAAAAA' ");
				return false;
			}
			return true;
		}, "memcpy(dest, 'coucou', 0) ").msg_err();

		result += SupraTest.test(null, () => {
			const string dest = "AAAAAAAAAA";
			var r = memcpy(dest.data, null, 0);
			if (r != dest) {
				stderr.printf("Return is not 'dest' ");
				return false;
			}
			if (Memory.cmp(dest.data, "AAAAAAAAAA", 10) != 0) {
				stderr.printf("Memory is not 'AAAAAAAAAAA' ");
				return false;
			}

			return true;
		}, "memcpy(dest, NULL, 0) ").msg_err();


		result += SupraTest.test(null, () => {
			const int size = 100;
			const string src = "\0\0abc";
			uint8 dest1[size + 1];
			uint8 dest2[size + 1];
			Memory.set(dest1, 'A', size);
			Memory.set(dest2, 'A', size);
			dest1[size] = '\0';
			dest2[size] = '\0';
			var r =ft_memcpy(dest1, src, 2);
			Memory.copy(dest2, src, 2);
			if (r != dest1) {
				stderr.printf("Return is not 'dest' ");
				return false;
			}
			if (Memory.cmp(dest1, dest2, size) != 0) {
				stderr.printf("\n>>> you: '%s' me %s ", (string)dest1, (string)dest2);
				return false;
			}
			return true;
		}, """ft_memcpy("AAAAAAAAAAAAAA...(100)", "\0\0abc", 2)""").msg_err();


		result += SupraTest.test(null, () => {
			const int size = 100;
			const string src = "Hello, World!";
			uint8 dest1[size + 1];
			uint8 dest2[size + 1];
			dest1[size] = '\0';
			dest2[size] = '\0';
			Memory.set(dest1, 'A', size);
			Memory.set(dest2, 'A', size);
			var r =ft_memcpy(dest1, src, 12);
			Memory.copy(dest2, src, 12);
			if (r != dest1) {
				stderr.printf("Return is not 'dest' ");
				return false;
			}
			if (Memory.cmp(dest1, dest2, size) != 0) {
				stderr.printf("\n>>> you: '%s' me %s ", (string)dest1, (string)dest2);
				return false;
			}
			return true;
		}, """ft_memcpy("AAAAAAAAAAAAAA...(100)", "Hello, World!", 12)""").msg_err();

		result += SupraTest.test(null, () => {
			const int size = 100;
			const string src = "abcdefghijklmnopqrstuvwxyz0123456789zyxwvutsrqponmlkjihgfedcba";
			uint8 dest1[size + 1];
			uint8 dest2[size + 1];
			Memory.set(dest1, 'A', size);
			Memory.set(dest2, 'A', size);
			dest1[size] = '\0';
			dest2[size] = '\0';
			var r =ft_memcpy(dest1, src, 61);
			Memory.copy(dest2, src, 61);
			if (r != dest1) {
				stderr.printf("Return is not 'dest' ");
				return false;
			}
			if (Memory.cmp(dest1, dest2, size) != 0) {
				stderr.printf("\n>>> you: '%s' me %s ", (string)dest1, (string)dest2);
				return false;
			}
			return true;
		}, """ft_memcpy("AAAAAAAAAAAAAA...(100)", "abcdefghijklmnopqrstuvwxyz0123456789zyxwvutsrqponmlkjihgfedcba, World!", 61)""").msg_err();


		result += SupraTest.test(null, () => {
			const int size = 42;
			const string src = "abcdefghijklmnopqrstuvwxyz0123456789zyxwvutsr\0";
			uint8 dest1[size + 1];
			uint8 dest2[size + 1];
			Memory.set(dest1, 'A', size);
			Memory.set(dest2, 'A', size);
			dest1[size] = '\0';
			dest2[size] = '\0';
			int i = 0;
			while (i != size) {
				void *r = null;
				r = ft_memcpy(dest1, src, i);
				Memory.copy(dest2, src, i);
				if (r != dest1) {
					stderr.printf("\n (loop: %d)>>> Your return is bad", i);
					return false;
				}
				if (Memory.cmp(dest1, dest2, size) != 0) {
					stderr.printf("\n(loop: %d)>>> you: '%s' me %s ", i, (string)dest1, (string)dest2);
					return false;
				}
				++i;
			}
			return true;
		}, """ft_memcpy("AAAAAAAAAAAAAA...(100)", "abcdefghijklmnopqrstuvwxyz0123456789zyxwvutsr", [[(loop 0->42)]]""").msg_err();

	}
	catch (Error e) {
		return @"$result \033[31m$(e.message)\033[0m";
	}
	return result;
}


string run_memmove() {
	string result = "MEMMOVE:  ";
	try {
		var ft_memmove = (d_memmove)loader.symbol("ft_memmove");
		result += SupraTest.test(null, () => {
			string mstr = "Hello, World!";
			char *str = (char*)mstr;
			size_t n = mstr.length + 1;
			ft_memmove(str + 7, str, n);
			return (str == "Hello, Hello, World!");
		}, "test same_memory").msg();


		result += SupraTest.test(null, () => {
			string mstr = "Hello, World!";
			char *str = (char*)mstr;
			size_t n = mstr.length + 1;
			ft_memmove(str + 2, str, n);
			return (str == "HeHello, World!");
		}, "test overlap").msg();

		result += SupraTest.test(null, () => {
			string msrc = "Source";
			char *src = msrc;
			char dest[20];
			size_t n = msrc.length + 1;
			ft_memmove(dest, src, n);
			return ((char*)dest == "Source");
			}, "test different_memory").msg();

		return result;
	}
	catch (Error e) {
		return @"$result \033[31m$(e.message)\033[0m";
	}
}

[CCode (cname = "strlcpy", cheader_filename="ctype.h,bsd/string.h")]
extern size_t strlcpy(char *dest, char *src, size_t size);


string run_strlcpy() {
	var result = new StringBuilder.sized(300);
	result.append("STRLCPY:  ");
	try {
		var ft_strlcpy = (d_strlcpy)loader.symbol("ft_strlcpy");

		string check(string dest, string src, size_t n) {
			return SupraTest.test(null, () => {
				char d1[21];
				char d2[21];
				char s1[21];
				char s2[21];
				Memory.set(d1, '\0', 20); Memory.copy(d1, dest, dest.length);
				Memory.set(d2, '\0', 20); Memory.copy(d2, dest, dest.length);
				Memory.set(s1, '\0', 20); Memory.copy(s1, src, src.length);
				Memory.set(s2, '\0', 20); Memory.copy(s2, src, src.length);
				size_t len1 = 0;
				size_t len2 = 0;

				len1 = ft_strlcpy(d1, s1, n);
				len2 = strlcpy(d2, s2, n);
				if (len1 != len2) {
					printerr("return > you: %zu, me: %zu", len1, len2);
					return false;
				}
				if (Memory.cmp(d1, d2, 20) != 0) {
					printerr("dest >  you: '%s' Me: '%s'", (string)d1 ?? "(null)", (string)d2 ?? "(null)");
					return false;
				}
				return true;
			}).msg_err(@"strlcpy('$dest', '$src', $n)");
		}
		/* 1 */ result.append(check("", "valac", 12));
		/* 2 */ result.append(check("valac", "", 12));
		/* 3 */ result.append(check("", "valac", 0));
		/* 4 */ result.append(check("valac", "", 0));
		/* 5 */ result.append(check("a", "valac", 4));
		/* 6 */ result.append(check("abc", "valac", 4));
		/* 7 */ result.append(check("a", "valac", 5));
		/* 8 */ result.append(check("a", "valac", 6));
		/* 9 */ result.append(check("abc", "valac", 7));
		/* 10 */ result.append(check("suprapatata", "valac", 15));
		/* 11 */ result.append(check("quarantedouze", "valac", 14));
		/* 12 */ result.append(check("quarantedouze", "valac", 19));
		/* 13 */ result.append(check("iiiiiiiiiiiiiiiiiiii", "yopato", 20));
		/* 14 */ result.append(check("2", "1", 0));
		/* 15 */ result.append(check("2", "1", 1));
		/* 16 */ result.append(check("1", "2", 2));
		/* 17 */ result.append(check("", "", 12));

		/* 18 */ result.append(SupraTest.test(null, () => {
			ft_strlcpy(null, "", 0);
			return true;
		}, "strlcpy(NULL, '', 0)").msg());

		/* 19 */ result.append(SupraTest.test(null, () => {
			ft_strlcpy(null, "", 1);
			return false;
		}, "strlcpy(NULL, '', 1) No Crash").msg_need_segfault());
		
		/* 20 */ result.append(SupraTest.test(null, () => {
			ft_strlcpy(null, null, 0);
			return false;
		}, "strlcpy(NULL, NULL, 0) No Crash").msg_need_segfault());

		/* 21 */ result.append(SupraTest.test(null, () => {
			ft_strlcpy(null, null, 1);
			return false;
		}, "strlcpy(NULL, NULL, 1) No Crash").msg_need_segfault());

		return (owned)result.str;
	}
	catch (Error e) {
		return @"$(result.str) \033[31m$(e.message)\033[0m";
	}
}

[CCode (cname = "strlcat", cheader_filename="ctype.h,bsd/string.h")]
extern size_t strlcat(char *dest, char *src, size_t size);


string run_strlcat() {
	var result = new StringBuilder.sized(300);
	result.append("STRLCAT:  ");
	try {
		var ft_strlcat = (d_strlcat)loader.symbol("ft_strlcat");

		string check(string dest, string src, size_t n) {
			return SupraTest.test(null, () => {
				char d1[61];
				char d2[61];
				char s1[61];
				char s2[61];
				Memory.set(d1, '\0', 20); Memory.copy(d1, dest, dest.length);
				Memory.set(d2, '\0', 20); Memory.copy(d2, dest, dest.length);
				Memory.set(s1, '\0', 20); Memory.copy(s1, src, src.length);
				Memory.set(s2, '\0', 20); Memory.copy(s2, src, src.length);
				size_t len1 = 0;
				size_t len2 = 0;

				len1 = ft_strlcat(d1, s1, n);
				len2 = strlcat(d2, s2, n);
				if (len1 != len2) {
					printerr("return > you: %zu, me: %zu", len1, len2);
					return false;
				}
				if (Memory.cmp(d1, d2, 20) != 0) {
					printerr("dest >  you: '%s' Me: '%s'", (string)d1 ?? "(null)", (string)d2 ?? "(null)");
					return false;
				}
				return true;
			}).msg_err(@"strlcat('$dest', '$src', $n)");
		}
		/* 1 */ result.append(check("", "valac", 12));
		/* 2 */ result.append(check("valac", "", 12));
		/* 3 */ result.append(check("", "valac", 0));
		/* 4 */ result.append(check("valac", "", 0));
		/* 5 */ result.append(check("a", "valac", 4));
		/* 6 */ result.append(check("abc", "valac", 4));
		/* 7 */ result.append(check("a", "valac", 5));
		/* 8 */ result.append(check("a", "valac", 6));
		/* 9 */ result.append(check("abc", "valac", 7));
		/* 10 */ result.append(check("suprapatata", "valac", 15));
		/* 11 */ result.append(check("quarantedouze", "valac", 14));
		/* 12 */ result.append(check("quarantedouze", "valac", 19));
		/* 13 */ result.append(check("iiiiiiiiiiiiiiiiiiii", "yopato", 20));
		/* 14 */ result.append(check("2", "1", 0));
		/* 15 */ result.append(check("2", "1", 1));
		/* 16 */ result.append(check("1", "2", 2));
		/* 17 */ result.append(check("", "", 12));
		/* 18 */ result.append(check("rrrrrrrrrrrrrrr", "lorem ipsum dolor sit amet", 5));

		/* 19 */ result.append(SupraTest.test(null, () => {
			ft_strlcat(null, "", 0);
			return true;
		}, "strlcat(NULL, '', 0)").msg());

		/* 20 */ result.append(SupraTest.test(null, () => {
			ft_strlcat(null, null, 0);
			return false;
		}, "strlcat(null, null, 0) No Crash").msg_need_segfault());

		/* 21 */ result.append(SupraTest.test(null, () => {
			ft_strlcat(null, null, 1);
			return false;
		}, "strlcat(null, null, 1) No Crash").msg_need_segfault());

		/* 22 */ result.append(SupraTest.test(null, () => {
			string str = "hello";
			ft_strlcat(str, null, 0);
			return false;
		}, "strlcat(\"hello\", null, 0) No Crash").msg_need_segfault());


		/* 23 */ result.append(SupraTest.test(null, () => {
			string str = "hello";
			ft_strlcat(str, null, 1);
			return false;
		}, "strlcat(\"hello\", NULL, 1) No Crash").msg_need_segfault());

		/* 24 */ result.append(SupraTest.test(null, () => {
			return (ft_strlcat(null, "source", 1) == 6);
		}, """strlcat(NULL, "source", 1) No Crash""").msg_need_segfault());

		/* 25 */ result.append(SupraTest.test(null, () => {
			return (ft_strlcat(null, "source", 0) == 6);
		}).msg("ft_strlcat(NULL, \"source\", 0) != 6"));


		/* 26 */ result.append(SupraTest.test(null, () => {
			string s = "abcdef";
			return (ft_strlcat(s, "source", 0) == 6);
		}).msg("ft_strlcat(\"abcdef\", \"source\", 0) != 6"));

		return (owned)result.str;
	}
	catch (Error e) {
		return @"$(result.str) \033[31m$(e.message)\033[0m";
	}
}

[CCode (cname = "toupper", cheader_filename="ctype.h")]
extern int clang_toupper(int c);

string run_toupper() {
	string result = "TOUPPER:  ";
	try {
		var ft_toupper= (d_toupper)loader.symbol("ft_toupper");
		var t = SupraTest.test(null, () => {
			for (int i = 0; i < 255; ++i)
			{
				if (ft_toupper(i) != clang_toupper(i))
					return false;
			}
			return true;
		});
		return result + t.msg();
	}
	catch (Error e) {
		return @"$result \033[31m$(e.message)\033[0m";
	}
}

[CCode (cname = "tolower", cheader_filename="ctype.h")]
extern int clang_tolower(int c);

string run_tolower() {
	string result = "TOLOWER:  ";
	try {
		var ft_tolower= (d_tolower)loader.symbol("ft_tolower");
		var t = SupraTest.test(null, () => {
				for (int i = 0; i < 255; ++i)
				{
					if (ft_tolower(i) != clang_tolower(i))
						return false;
				}
				return true;
			});
		return result + t.msg();
	}
	catch (Error e) {
		return @"$result \033[31m$(e.message)\033[0m";
	}
}

[CCode (cname = "strchr", cheader_filename="string.h")]
extern char* strchr(char *s, int c);

string run_strchr() {
	string result = "STRCHR:   ";
	try {
		var ft_strchr = (d_strchr)loader.symbol("ft_strchr");

		string check (char* s, int c, string? msg = null) {
			string cp;
			if (c == '\0')
				cp = "'\\0'";
			else
				cp = ((char)c).to_string();
			var p = SupraTest.test(null, () => {
				var a = strchr(s, c);
				var b = ft_strchr(s, c);
				if (a != b) {
					stderr.printf("libc: %s you: %s ", ((string)a) ?? "null", ((string)b) ?? "(null)");
					return false;
				}
				return true;
			}, msg.printf(cp)).msg_err();
			return (owned)p;
		}

		result += check("suprapatata\0vttiX",	's', """strchr("suprapatata\0vttiX", '%s')""");
		result += check("suprapatata\0vttiX",	'a', """strchr("suprapatata\0vttiX", '%s')""");
		result += check("suprapatata\0vttiX",	'v', """strchr("suprapatata\0vttiX", '%s')""");
		result += check("suprapatata\0vttiX",	'p', """strchr("suprapatata\0vttiX", '%s')""");
		result += check("suprapatata\0vttiX",	'r', """strchr("suprapatata\0vttiX", '%s')""");
		result += check("suprapatata\0vttiX",	't', """strchr("suprapatata\0vttiX", '%s')""");
		result += check("suprapatata\0vttiX",	'X', """strchr("suprapatata\0vttiX", '%s')""");
		result += check("suprapatata\0vttiX",	'b', """strchr("suprapatata\0vttiX", '%s')""");
		result += check("suprapatata\0vttiX",	'i', """strchr("suprapatata\0vttiX", '%s')""");
		result += check("suprapatata\0vttiX",	'E', """strchr("suprapatata\0vttiX", '%s')""");
		result += check("suprapatata\0vttiX",	'\0', """strchr("suprapatata\0vttiX", '%s')""");
		result += check("Hey Supra",			'\0', """strchr("Hey Supra", '%s')""");
		result += check("\0",					'\0', """strchr("\0", '%s')""");

		result += SupraTest.test(null, () => {
				const string s = "\0";
				int c = '\0';
				return (strchr(s, c) == ft_strchr(s, c));
		}, """strchr("\0", '\0')""").msg();

		result += SupraTest.test(null, () => {
				const string s = "1024";
				int c = '\0';
				return (strchr(s, c) == ft_strchr(s, c));
		}, """strchr("1024", '\0')""").msg();
		
		result += SupraTest.test(null, () => {
				const string s = "1024";
				int c = 't' + 256;
				return (strchr(s, c) == ft_strchr(s, c));
		}, """strchr("1024", ('t' + 256))""").msg();

		result += SupraTest.test(null, () => {
				ft_strchr(null, '\0');
				return false;
		}, """strchr(NULL, '\0')""").msg_need_segfault();

		result += SupraTest.test(null, () => {
				ft_strchr(null, 'c');
				return false;
		}, """strchr(NULL, 'c')""").msg_need_segfault();
	}
	catch (Error e) {
		return @"$result \033[31m$(e.message)\033[0m";
	}
	return result;
}

[CCode (cname = "strrchr", cheader_filename="string.h")]
extern char *strrchr(char *s, int c);

string run_strrchr() {
	string result = "STRRCHR:  ";
	try {
		var ft_strrchr = (d_strrchr)loader.symbol("ft_strrchr");

		string check (char* s, int c, string? msg = null) {
			string cp;
			if (c == '\0')
				cp = "'\\0'";
			else
				cp = ((char)c).to_string();
			var p = SupraTest.test(null, () => {
				var a = strrchr(s, c);
				var b = ft_strrchr(s, c);
				if (a != b) {
					stderr.printf("libc: %s you: %s ", ((string)a) ?? "null", ((string)b) ?? "(null)");
					return false;
				}
				return true;
			}, msg.printf(cp)).msg_err();
			return (owned)p;
		}

		result += check("suprapatata\0vttiX",	's', """strrchr("suprapatata\0vttiX", '%s')""");
		result += check("suprapatata\0vttiX",	'a', """strrchr("suprapatata\0vttiX", '%s')""");
		result += check("suprapatata\0vttiX",	'v', """strrchr("suprapatata\0vttiX", '%s')""");
		result += check("suprapatata\0vttiX",	'p', """strrchr("suprapatata\0vttiX", '%s')""");
		result += check("suprapatata\0vttiX",	'r', """strrchr("suprapatata\0vttiX", '%s')""");
		result += check("suprapatata\0vttiX",	't', """strrchr("suprapatata\0vttiX", '%s')""");
		result += check("suprapatata\0vttiX",	'X', """strrchr("suprapatata\0vttiX", '%s')""");
		result += check("suprapatata\0vttiX",	'b', """strrchr("suprapatata\0vttiX", '%s')""");
		result += check("suprapatata\0vttiX",	'i', """strrchr("suprapatata\0vttiX", '%s')""");
		result += check("suprapatata\0vttiX",	'E', """strrchr("suprapatata\0vttiX", '%s')""");
		result += check("suprapatata\0vttiX",	'\0', """strrchr("suprapatata\0vttiX", '%s')""");
		result += check("Hey Supra",			'\0', """strrchr("Hey Supra", '%s')""");
		result += check("\0",					'\0', """strrchr("\0", '%s')""");

		result += SupraTest.test(null, () => {
				const string s = "bonjour";
				int c = 'b';
				return (strrchr(s.offset(2), c) == ft_strrchr(s.offset(2), c));
		}, """buf = "bonjour" strrchr(buf + 2, 'b') """).msg();
		
		result += SupraTest.test(null, () => {
				const string s = "1024";
				int c = 't' + 256;
				return (strrchr(s, c) == ft_strrchr(s.offset(2), c));
		}, """buf = "1024" strrchr(buf, ('t' + 256) (unsigned char) """).msg();

		result += SupraTest.test(null, () => {
				ft_strrchr(null, '\0');
				return false;
		}, """strrchr(NULL, '\0')""").msg_need_segfault();

		result += SupraTest.test(null, () => {
				ft_strrchr(null, 'c');
				return false;
		}, """strrchr(NULL, 'c')""").msg_need_segfault();
	}
	catch (Error e) {
		return @"$result \033[31m$(e.message)\033[0m";
	}
	return result;
}

[CCode (cname = "strncmp", cheader_filename="string.h")]
extern int strncmp(char *s1, char* s2, size_t n);


string run_strncmp() {
	var result = new StringBuilder("STRNCMP:  ");
	try {
		var ft_strncmp = (d_strncmp)loader.symbol("ft_strncmp");

		string check(char *s1, char *s2, size_t n, string? msg = null) {
			var t = SupraTest.test(null, () => {
				var a = strncmp(s1, s2, n);
				var b = ft_strncmp(s1, s2, n);
				printerr("libc: %d you: %d ", a, b);
				return (clang_s(strncmp(s1, s2, n)) == clang_s(ft_strncmp(s1, s2, n)));
			}, @"strncmp('$((string)s1)', '$((string)s2)', $n) ");
			if (t.status == KO)
				return t.msg_ko(msg ?? t.message + t.stderr);
			return t.msg();
		}
		/* 1 */ result.append(check("a", "b", 1));
		/* 2 */ result.append(check("", "", 4));
		/* 3 */ result.append(check("bjr\0kitty", "bjr\0hello", 7));
		/* 4 */ result.append(check("abcd", "abce", 3));
		/* 5 */ result.append(check("test\0", "", 6));
		/* 6 */ result.append(check("", "test\0", 6));
		uint8 []uc_test = {'t', 'e', 's', 't', 128};
		/* 7 */ result.append(check(uc_test, "test\0", 6, "Unsigned-Char ?"));
		/* 8 */ result.append(check("Portal2", "TheCakeIsALie", 4));
		/* 9 */ result.append(check("", "TheCakeIsALie", 4));
		/* 10 */ result.append(check("Portal2", "", 4));
		/* 11 */ result.append(check("fhfghfgdjhsffg", "dfghfdhsfd", 5));
		/* 11 */ result.append(check("abcdefgh", "abcdwxyz", 4));
		/* 11 */ result.append(check("zyxbcdefgh", "abcdwxyz", 0));
		/* 11 */ result.append(check("abcdefgh", "", 0));
	}
	catch (Error e) {
		return @"$(result.str) \033[31m$(e.message)\033[0m";
	}
	return (owned)result.str;
}


string run_memchr() {
	var result = new StringBuilder("MEMCHR:   ");
	try {
		var ft_memchr= (d_memchr)loader.symbol("ft_memchr");
		char s[] = {0, 1, 2 ,3 ,4 ,5};

		// 1
		result.append(SupraTest.test(null, ()=>{
			return (ft_memchr(s, 0, 0) == null);
		}, @"memchr({0, 1, 2, 3, 4, 5}, 0, 0) == null").msg());

		// 2
		result.append(SupraTest.test(null, ()=>{
			return (ft_memchr(s, 0, 1) == s);
		}, @"memchr({0, 1, 2, 3, 4, 5}, 0, 1) == tab").msg());

		// 3
		result.append(SupraTest.test(null, ()=>{
			return (ft_memchr(s, 2, 3) == &s[2]);
		}, @"memchr({0, 1, 2, 3, 4, 5}, 2, 3) == &tab[2]").msg());

		// 4
		result.append(SupraTest.test(null, ()=>{
			return (ft_memchr(s, 6, 6) == null);
		}, @"memchr({0, 1, 2, 3, 4, 5}, 6, 6) == null").msg());

		// 5
		result.append(SupraTest.test(null, ()=>{
			return (ft_memchr(s, (2 + 256), 3) == &s[2]);
		}, @"memchr({0, 1, 2, 3, 4, 5}, (2 + 256), 3) == &tab[2]").msg());

		// 6
		result.append(SupraTest.test(null, () => {
			ft_memchr(null, 'e', 0);
			return true;
		}, "memchr(null, 'e', 0)").msg());

		// 7
		result.append(SupraTest.test(null, () => {
			ft_memchr(null, 'e', 1);
			return false;
		}, "No segfault with memchr(null, 'e', 1)").msg_need_segfault());
		

		return (owned)result.str;
	}
	catch (Error e) {
		return @"$(result.str) \033[31m$(e.message)\033[0m";
	}
}

[CCode (cname = "memcmp", cheader_filename="string.h")]
extern int memcmp(void *s1, void* s2, size_t n);

string run_memcmp() {
	string result = "MEMCMP:   ";
	try {
		var ft_memcmp = (d_memcmp)loader.symbol("ft_memcmp");
		string check(void *m1, void *m2, size_t len, string msg = ""){
			var t = SupraTest.test(null, ()=> {
				var y = ft_memcmp(m1, m2, len);
				var m = memcmp(m1, m2, len);
				if (clang_s(m) == clang_s(y))
					return true;
				stderr.printf("you: %d, Me: %d", y, m);
				return false;
			});
			string msg_dup;

			if (msg == ""){
				string s1;
				string s2;
				s1 = (string)m1;
				s2 = (string)m2;
				msg_dup = @"memcmp('$s1', '$s2', $len)";
			}
			else {
				msg_dup = msg;
			}

			return t.msg_err(msg_dup);
		}

		uint8 []p = {'t', 128, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};

		result += check("salut", "salut", 5);
		result += check(p, "t\0", 2, "memcmp('t\\200', 't\\0', 2)");
		result += check("testss", "test", 5);
		result += check("test", "tEst", 4);
		result += check("", "test", 4);
		result += check("test", "", 4);
		result += check("supra\0vim", "supra\0pack", 8, "memcmp('supra\\0vim', 'supra\\0pack', 8)");
		result += check("abcdefghij", "abcdefgxyz", 7);
		result += check("abcdefgh", "abcdwxyz", 6);
		result += check("zyxbcdefgh", "abcdefgxyz", 0);
	}
	catch (Error e) {
		return @"$result \033[31m$(e.message)\033[0m";
	}
	return result;
}

[CCode (cname = "strnstr", cheader_filename="bsd/string.h")]
extern unowned string? strnstr(char *s1, char* s2, size_t n);

string run_strnstr() {
	string result = "STRNSTR:  ";
	try {
		var ft_strnstr= (d_strnstr)loader.symbol("ft_strnstr");
		string check(char* s1, char* s2, size_t n) {
			return SupraTest.test(null, ()=>{
				char* a = ft_strnstr(s1, s2, n);
				char* b = strnstr(s1, s2, n);
				if (a != b) {
					stderr.printf("strnstr('%s', '%s', %ld) you: %s, me: %s ", (string)s1, (string)s2, (long)n, (string)a ?? "(null)", (string)b ?? "(null)");
					return false;
				}
				return true;
			}).msg_err();
		}
		/* 1 */  result += check("a", "super magique", 3);
		/* 2 */  result += check("a", "super magique", 42);
		/* 3 */  result += check("abc", "zzzzzzzzzzzabczzzzzzzzz", 3);
		/* 4 */  result += check("abc", "zzzzzzzzzzzabczzzzzzzzz", 42);
		/* 5 */  result += check("", "zzzzzzzzzzzabczzzzzzzzz", 42);
		/* 6 */  result += check("", "", 42);
		/* 7 */  result += check("", "", 0);
		/* 8 */  result += check("zzzzzzzzzzzabczzzzzzzzz", "", 42);
		/* 9 */  result += check("supravim n'est point un IDE", "vim", 42);
		/* 10 */  result += check("supravim n'est point un IDE", "vim", 8);
		/* 11 */  result += check("supravim n'est point un IDE", "vim", 7);
		/* 12 */  result += check("supravim n'est point un IDE", "vim", 6);
		/* 13 */  result += check("hello\0world", "world", 42);
		/* 14 */  result += check("lorem ipsum dolor sit amet", "dol", 30);
		/* 15 */  result += check("lorem ipsum dolor sit amet", "consectetur", 30);
		/* 16 */  result += check("lorem ipsum dolor sit amet", "sit", 10);
		/* 17 */  result += check("lorem ipsum dolor sit amet", "dolor", 15);
		/* 18 */  result += check("lorem ipsum dolor sit amet", "dolor", 0);

		return result;
	}
	catch (Error e) {
		return @"$result \033[31m$(e.message)\033[0m";
	}
}

// atoi
[CCode (cname = "atoi", cheader_filename="stdlib.h")]
extern int atoi(string s1);

string run_atoi() {
	var result = new StringBuilder.sized(200);
	result.append("ATOI:     ");
	try {
		var ft_atoi = (d_atoi)loader.symbol("ft_atoi");
		string check(string s_nb){
			return SupraTest.test(null, () => {
				var a = ft_atoi(s_nb);
				var b = atoi(s_nb);
				stderr.printf("You:%d Me:%d", a, b);
				return (a == b);
			}).msg_err(@"Atoi('$s_nb')");
		}
		/* 1 */ result.append(check("2147483647"));
		/* 2 */ result.append(check("-2147483648"));
		/* 3 */ result.append(check("0"));
		/* 4 */ result.append(check("1"));
		/* 5 */ result.append(check("2"));
		/* 6 */ result.append(check("9"));
		/* 7 */ result.append(check("10"));
		/* 8 */ result.append(check("11"));
		/* 9 */ result.append(check("42"));
		/* 10 */ result.append(check("-1"));
		/* 11 */ result.append(check("-2"));
		/* 12 */ result.append(check("-9"));
		/* 13 */ result.append(check("-10"));
		/* 14 */ result.append(check("-11"));
		/* 15 */ result.append(check("-42"));
		/* 16 */ result.append(check("165468465"));
		/* 17 */ result.append(check("   \t\r\f\v\t-2145"));
		/* 18 */ result.append(check("   \t\t--2145"));
		/* 19 */ result.append(check("   \t\t-a2145"));
		/* 20 */ result.append(check("   \t\t-8a2145"));
		/* 21 */ result.append(check("   \n 28fkldjgd42"));
		/* 22 */ result.append(check("   \n\f\r\n\t\v"));
		/* 23 */ result.append(check("+999"));
		/* 24 */ result.append(check(" 000002147483647"));
		/* 25 */ result.append(check(" 000-2147483648"));

		/* 26 */
		for (int N = 0; N < 5; ++N)
		{
			var i = Random.int_range(int.MIN, int.MAX);
			result.append(check(@"$i"));
		}
		return (owned)result.str;
	}
	catch (Error e) {
		return @"$(result.str) \033[31m$(e.message)\033[0m";
	}
}


string run_calloc() {
	string result = "CALLOC:   ";
	try {
		var ft_calloc = (d_calloc)loader.symbol("ft_calloc");

		SupraTest.Test t;

		/* 1 */ t = SupraTest.test(null, () => {
			char *m = ft_calloc(52, sizeof(char));

			for (int i = 0; i < 52; ++i)
			{
				if (m[i] != '\0') {
					delete m;
					return false;
				}
			}
			delete m;
			return (true);
		}, "calloc(52)");
		if (t.alloc != 1)
			result += t.msg_ko(@"No alloc ??? $(t.alloc)");
		else
			result += t.msg_ok();
		/* 2 */ result += t.msg();

		/* 3 */ result += SupraTest.test(null, ()=>{
			SupraLeak.send_null();
			char *s = ft_calloc(42, 1);
			if (s != null)
				delete s;
			return (s == null);
		}).msg_err("no protect malloc (send null) ");


		/* 4 */ t = SupraTest.test(null, ()=>{
			bool stats;
			void* mem = ft_calloc(0, 1);
			stats = (mem != null);
			free(mem);
			return (stats);
		});
		if (t.bytes == 0)
			result += t.msg_ok();
		else
			result += t.msg_ko("dont alloc with calloc(0, 1)");

		/* 5 */ t = SupraTest.test(null, ()=>{
			bool stats;
			void* mem = ft_calloc(1, 0);
			stats = (mem != null);
			free(mem);
			return (stats);
		});
		if (t.bytes == 0)
			result += t.msg_ok();
		else
			result += t.msg_ko("dont alloc with calloc(1, 0)");

		/* 6 */ t = SupraTest.test(null, ()=>{
			bool stats;
			void* mem = ft_calloc(0, 0);
			stats = (mem != null);
			free(mem);
			return (stats);
		});
		if (t.bytes == 0)
			result += t.msg_ok();
		else
			result += t.msg_ko("dont alloc with calloc(0, 0)");


		return result;
	}
	catch (Error e) {
		return @"$result \033[31m$(e.message)\033[0m";
	}
}


string run_strdup() {
	var result = new StringBuilder("STRDUP:   ");
	try {
		var ft_strdup = (d_strdup)loader.symbol("ft_strdup");

		string check(char *cmp) {
			var t = SupraTest.test(null, () => {
				char* s = ft_strdup(cmp);

				if (s == null)
					return false;
				return ((string)s == (string)cmp);
			}, "strdup('$cmp')");
			if (t.alloc != 1)
				return t.msg_ko(@"No alloc ??? $(t.alloc) alloc");
			if (t.bytes != ((string)cmp).length + 1)
				return t.msg_ko(@"Bad alloc size $(t.bytes)");
			return t.msg_ok();
		}

		/* 1 */ result.append(check("abc"));
		/* 2 */ result.append(check("Abc"));
		/* 3 */ result.append(check("abc\0yop"));
		/* 4 */ result.append(check("abc 12345\0yop"));
		/* 5 */ result.append(check("abc 12345\0yop"));
		/* 6 */ result.append(check("lorem ipsum dolor sit amet"));
		/* 7 */ result.append(check("lorem ipsum dolor sit amet lorem ipsum dolor sit amet"));
		/* 8 */ result.append(check(""));

		// Test if strdup segfault
		/* 9 */ result.append(SupraTest.test(null, () => {
			ft_strdup(null);
			return false;
		}, "strdup(NULL) NOCRASH").msg_need_segfault());

		// Test if strdup protect (malloc)
		/* 5 */ result.append(SupraTest.test(null, ()=>{
			SupraLeak.send_null();
			char *s = ft_strdup("bababababhc");
			if (s != null)
				delete s;
			return (s == null);
		}).msg_err("no protect "));

		return (owned)result.str;
	}
	catch (Error e) {
		return @"$(result.str) \033[31m$(e.message)\033[0m";
	}
}
