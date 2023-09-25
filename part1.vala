

int clang_s(int n) {
	if (n == 0)
		return 0;
	return 1;
}

long clang_sl(long n) {
	if (n == 0)
		return 0;
	return 1;
}

[CCode (cname = "isalpha", cheader_filename="ctype.h")]
extern int clang_isalpha(int c);
delegate int d_isalpha(int c);
string run_isalpha() {
	string result = "IS_ALPHA: ";
	try {
		var ft_isalpha= (d_isalpha)loader.symbol("ft_isalpha");
		var t = Test.complex(2, () => {
			for (int i = 0; i < 255; ++i)
			{
				if (clang_s(ft_isalpha(i)) != clang_s(clang_isalpha(i)))
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

[CCode (cname = "isdigit", cheader_filename="ctype.h")]
extern int clang_isdigit(int c);
delegate int d_isdigit(int c);
string run_isdigit() {
	string result = "ISDIGIT:  ";
	try {
		var ft_isdigit= (d_isdigit)loader.symbol("ft_isdigit");
		var t = Test.complex(2, () => {
				for (int i = 0; i < 255; ++i)
				{
					if (clang_s(ft_isdigit(i)) != clang_s(clang_isdigit(i)))
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

[CCode (cname = "isalnum", cheader_filename="ctype.h")]
extern int clang_isalnum(int c);
delegate int d_isalnum(int c);
string run_isalnum() {
	string result = "ISALNUM:  ";
	try {
		var ft_isalnum= (d_isalnum)loader.symbol("ft_isalnum");
		var t = Test.complex(2, () => {
			for (int i = 0; i < 255; ++i)
			{
				if (clang_s(ft_isalnum(i)) != clang_s(clang_isalnum(i)))
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

[CCode (cname = "isascii", cheader_filename="ctype.h")]
extern int clang_isascii(int c);
delegate int d_isascii(int c);
string run_isascii() {
	string result = "ISASCII:  ";
	try {
		var ft_isascii= (d_isascii)loader.symbol("ft_isascii");
		var t = Test.complex(2, () => {
				for (int i = 0; i < 255; ++i)
				{
					if (clang_s(ft_isascii(i)) != clang_s(clang_isascii(i)))
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

[CCode (cname = "isprint", cheader_filename="ctype.h")]
extern int clang_isprint(int c);
delegate int d_isprint(int c);
string run_isprint() {
	string result = "ISPRINT:  ";
	try {
		var ft_isprint= (d_isprint)loader.symbol("ft_isprint");
		var t = Test.complex(2, () => {
				for (int i = 0; i < 255; ++i)
				{
					if (clang_s(ft_isprint(i)) != clang_s(clang_isprint(i)))
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

delegate int d_strlen(string? s);
string run_strlen() {
	string result = "STRLEN:   ";
	try {
		var ft_strlen = (d_strlen)loader.symbol("ft_strlen");
		result += Test.complex(2, () => { return (ft_strlen("1") == 1); }, "1").msg();
		result += Test.complex(2, () => { return (ft_strlen("12") == 2); }, "2").msg();
		result += Test.complex(2, () => { return (ft_strlen("123") == 3); }, "3").msg();
		result += Test.complex(2, () => { return (ft_strlen("1234") == 4); }, "4").msg();
		result += Test.complex(2, () => { return (ft_strlen("12345") == 5); }, "5").msg();
		result += Test.complex(2, () => { return (ft_strlen("   \t\t\t\r\n") == 8); }, "8 spaces").msg();
		var t = Test.complex(2, ()=>{
			ft_strlen(null);
			return false;
		}, "No segfault with strlen(null)");
		if (t.status != SIGSEGV)
			result += t.msg();
		
		return result;
	}
	catch (Error e) {
		return @"$result \033[31m$(e.message)\033[0m";
	}
}

delegate int d_memset(void* mem, char c, int nb);
string run_memset() {
	string result = "MEMSET:   ";
	try {
		var ft_memset = (d_memset)loader.symbol("ft_memset");
		result += Test.complex(2, () => {
			uint8 buf[20];
			ft_memset(buf, 'E', 6);
			buf[6] = '\0';
			return((string)buf == "EEEEEE");
		}, "memset(mem, E, 6)").msg();
		result += Test.complex(2, () => {
			uint8 buf[20];
			ft_memset(buf, 'E', 6);
			buf[6] = '\0';
			return(buf[7] != 'E');
		}, "trop loin...").msg();
		result += Test.complex(2, () => {
			uint8 buf[20];
			buf[5] = '\0';
			ft_memset(buf, 'E', 6);
			buf[6] = '\0';
			return(buf[5] == 'E');
		}, "pas asser loin...").msg();
		result += Test.complex(2, () => {
			uint8 buf[5];
			buf[0] = 'J';
			ft_memset(buf, 'E', 0);
			return(buf[0] == 'J');
		}, "bug avec memset 0").msg();
		return result;
	}
	catch (Error e) {
		return @"$result \033[31m$(e.message)\033[0m";
	}
}

delegate int d_bzero(void* mem, int nb);
string run_bzero() {
	string result = "BZERO:    ";
	try {
		var ft_bzero = (d_bzero)loader.symbol("ft_bzero");
		for (int i = 0; i < 25; ++i)
		{
			result += Test.complex(2, () => {
				uint8 buf1[40];
				uint8 buf2[40];
				Memory.set(buf1, 'X', 40);
				Memory.set(buf2, 'X', 40);
				
				ft_bzero(buf1, i);
				Memory.set(buf2, '\0', i);
				if (Memory.cmp(buf1, buf2, i) == 0)
					return true; 
				return false;
			}, @"bzero(mem, E, $i)").msg();
		}
		return result;
	}
	catch (Error e) {
		return @"$result \033[31m$(e.message)\033[0m";
	}
}

//TODO memcpy
//TODO memmove
//TODO strlcpy 
//TODO strlcat 

[CCode (cname = "toupper", cheader_filename="ctype.h")]
extern int clang_toupper(int c);
delegate int d_toupper(int c);
string run_toupper() {
	string result = "TOUPPER:  ";
	try {
		var ft_toupper= (d_toupper)loader.symbol("ft_toupper");
		var t = Test.complex(2, () => {
			for (int i = 0; i < 255; ++i)
			{
				if (clang_s(ft_toupper(i)) != clang_s(clang_toupper(i)))
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
delegate int d_tolower(int c);
string run_tolower() {
	string result = "TOLOWER:  ";
	try {
		var ft_tolower= (d_tolower)loader.symbol("ft_tolower");
		var t = Test.complex(2, () => {
				for (int i = 0; i < 255; ++i)
				{
					if (clang_s(ft_tolower(i)) != clang_s(clang_tolower(i)))
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
extern char *strchr(char *s, int c);
delegate char *d_strchr(char *s, int c);
string run_strchr() {
	string result = "STRCHR:   ";
	try {
		var ft_strchr = (d_strchr)loader.symbol("ft_strchr");
		
		result += Test.complex(2, () => {
				string s = "suprapatata\0vttiX";
				int c = 's';
				return (strchr(s, c) == ft_strchr(s, c));
		}, """strchr("suprapatata\0vttiX", 's')""").msg();
		result += Test.complex(2, () => {
				string s = "suprapatata\0vttiX";
				int c = 'a';
				return (strchr(s, c) == ft_strchr(s, c));
		}, """strchr("suprapatata\0vttiX", 'a')""").msg();
		result += Test.complex(2, () => {
				string s = "suprapatata\0vttiX";
				int c = 'p';
				return (strchr(s, c) == ft_strchr(s, c));
		}, """strchr("suprapatata\0vttiX", 'a')""").msg();
		result += Test.complex(2, () => {
				string s = "suprapatata\0vttiX";
				int c = 'v';
				return (strchr(s, c) == ft_strchr(s, c));
		}, """strchr("suprapatata\0vttiX", 'v')""").msg();
		result += Test.complex(2, () => {
				string s = "suprapatata\0vttiX";
				int c = 'X';
				return (strchr(s, c) == ft_strchr(s, c));
		}, """strchr("suprapatata\0vttiX", 'X')""").msg();
	}
	catch (Error e) {
		return @"$result \033[31m$(e.message)\033[0m";
	}
	return result;
}


[CCode (cname = "strrchr", cheader_filename="string.h")]
extern char *strrchr(char *s, int c);
delegate char *d_strrchr(char *s, int c);
string run_strrchr() {
	string result = "STRRCHR:  ";
	try {
		var ft_strrchr = (d_strrchr)loader.symbol("ft_strrchr");
		
		result += Test.complex(2, () => {
				string s = "suprapatata\0vttiX";
				int c = 's';
				return (strrchr(s, c) == ft_strrchr(s, c));
		}, """strrchr("suprapatata\0vttiX", 's')""").msg();
		result += Test.complex(2, () => {
				string s = "suprapatata\0vttiX";
				int c = 'a';
				return (strrchr(s, c) == ft_strrchr(s, c));
		}, """strrchr("suprapatata\0vttiX", 'a')""").msg();
		result += Test.complex(2, () => {
				string s = "suprapatata\0vttiX";
				int c = 'p';
				return (strrchr(s, c) == ft_strrchr(s, c));
		}, """strrchr("suprapatata\0vttiX", 'a')""").msg();
		result += Test.complex(2, () => {
				string s = "suprapatata\0vttiX";
				int c = 'v';
				return (strrchr(s, c) == ft_strrchr(s, c));
		}, """strrchr("suprapatata\0vttiX", 'v')""").msg();
		result += Test.complex(2, () => {
				string s = "suprapatata\0vttiX";
				int c = 'X';
				return (strrchr(s, c) == ft_strrchr(s, c));
		}, """strrchr("suprapatata\0vttiX", 'X')""").msg();
	}
	catch (Error e) {
		return @"$result \033[31m$(e.message)\033[0m";
	}
	return result;
}

[CCode (cname = "strncmp", cheader_filename="string.h")]
extern int strncmp(uint8 *s1, uint8* s2, size_t n);
delegate int d_strncmp(uint8 *s1, uint8 *s2, size_t n);
string run_strncmp() {
	string result = "STRNCMP:  ";
	try {
		var ft_strncmp = (d_strncmp)loader.symbol("ft_strncmp");
		uint8 *s1 = "abcd";
		uint8 *s2 = "abce";
		size_t nb = 3;
		result += Test.complex(2, () => {
			return (clang_s(strncmp(s1, s2, nb)) == clang_s(ft_strncmp(s1, s2, nb)));
		}, @"strncmp($s1, $s2 $nb)").msg();
		s1 = "bjr\0kitty"; s2 = "bjr\0hello"; nb = 7;
		result += Test.complex(2, () => {
			return (clang_s(strncmp(s1, s2, nb)) == clang_s(ft_strncmp(s1, s2, nb)));
		}, @"strncmp($((string)s1), $((string)s2) $nb)").msg();
		s1 = "bjr\0kitty"; s2 = "bjr\0hello"; nb = 7;
		result += Test.complex(2, () => {
			return (clang_s(strncmp(s1, s2, nb)) == clang_s(ft_strncmp(s1, s2, nb)));
		}, @"strncmp('bjr\\0kitty', 'bjr\\0hello' $nb) Qui a demandé un memcmp ?").msg();
		s2 = "test\0"; nb = 6;
		uint8 []uc_test = {'t', 'e', 's', 't', 128};
		s1 = uc_test;
		result += Test.complex(2, () => {
			return (clang_s(strncmp(s1, s2, nb)) == clang_s(ft_strncmp(s1, s2, nb)));
		}, @"Unsigned Char ???").msg();
		
		s1 = "Portal2"; s2 = "TheCakeIsALie"; nb = 4;
		result += Test.test(3, () => {
			return (clang_s(strncmp(s1, s2, nb)) == clang_s(ft_strncmp(s1, s2, nb)));
		}, @"strncmp($((string)s1), $((string)s2) $nb)").msg();
		s1 = ""; s2 = "TheCakeIsALie"; nb = 4;
		result += Test.test(3, () => {
			return (clang_s(strncmp(s1, s2, nb)) == clang_s(ft_strncmp(s1, s2, nb)));
		}, @"strncmp('', $((string)s2) $nb)").msg();
		s1 = "Portal2"; s2 = ""; nb = 4;
		result += Test.test(3, () => {
			return (clang_s(strncmp(s1, s2, nb)) == clang_s(ft_strncmp(s1, s2, nb)));
		}, @"strncmp($((string)s1), '' $nb)").msg();
		s1 = ""; s2 = ""; nb = 4;
		result += Test.complex(3, () => {
			return (clang_s(strncmp(s1, s2, nb)) == clang_s(ft_strncmp(s1, s2, nb)));
		}, @"strncmp('', '', $nb)").msg();
		s1 = "fhfghfgdjhsffg"; s2 = "dfghfdhsfd"; nb = 5;
		result += Test.complex(3, () => {
			return (clang_s(strncmp(s1, s2, nb)) == clang_s(ft_strncmp(s1, s2, nb)));
		}, @"strncmp('', '', $nb)").msg();
	}
	catch (Error e) {
		return @"$result \033[31m$(e.message)\033[0m";
	}
	return result;
}

delegate void* d_memchr(void* s1, int c, size_t n);
string run_memchr() {
	string result = "MEMCHR:   ";
	try {
		var ft_memchr= (d_memchr)loader.symbol("ft_memchr");
		char s[] = {0, 1, 2 ,3 ,4 ,5};
		
		result += Test.complex(2, ()=>{
			return (ft_memchr(s, 0, 0) == null);
		}, @"memchr(0, 0)").msg();
		
		result += Test.complex(2, ()=>{
			return (ft_memchr(s, 0, 1) == s);
		}, @"memchr(0, 1)").msg();
		
		result += Test.complex(2, ()=>{
			return (ft_memchr(s, 2, 3) == &s[2]);
		}, @"memchr(2, 3)").msg();

		result += Test.complex(2, ()=>{
			return (ft_memchr(s, 6, 6) == null);
		}, @"memchr(6, 6)").msg();

		result += Test.complex(2, ()=>{
			return (ft_memchr(s, 2 + 256, 3) == &s[2]);
		}, @"memchr(2 + 256, 3)").msg();
		return result;
	}
	catch (Error e) {
		return @"$result \033[31m$(e.message)\033[0m";
	}
}


[CCode (cname = "memcmp", cheader_filename="string.h")]
extern int memcmp(void *s1, void* s2, size_t n);
delegate int d_memcmp(void* s1, void* s2, size_t n);
string run_memcmp() {
	string result = "MEMCMP:   ";
	try {
		var ft_memcmp = (d_memcmp)loader.symbol("ft_memcmp");
		uint8 *s1 = "abcd";
		uint8 *s2 = "abce";
		size_t nb = 3;
		result += Test.complex(2, () => {
			return (clang_s(memcmp(s1, s2, nb)) == clang_s(ft_memcmp(s1, s2, nb)));
		}, @"memcmp($s1, $s2 $nb)").msg(); 
		s1 = "bjr\0kitty"; s2 = "bjr\0hello"; nb = 5;
		result += Test.complex(2, () => {
			printerr("ft: %d ", ft_memcmp(s1, s2, nb));
			printerr("gc: %d ", memcmp(s1, s2, nb));
			return (clang_s(memcmp(s1, s2, nb)) == clang_s(ft_memcmp(s1, s2, nb)));
		}, @"memcmp('bjr\\0kitty', 'bjr\\0hello' $nb)").msg();
	}
	catch (Error e) {
		return @"$result \033[31m$(e.message)\033[0m";
	}
	return result;
}

[CCode (cname = "strnstr", cheader_filename="string.h")]
extern char* strnstr(char *s1, char* s2, size_t n);
delegate char* d_strnstr(char* s1, char* s2, size_t n);
string run_strnstr() {
	string result = "STRNSTR:  ";
	try {
		var ft_strnstr= (d_strnstr)loader.symbol("ft_strnstr");
		string check(char* s1, char* s2, size_t n) {
			var t = Test.complex(2, ()=>{
				return (clang_sl((long)ft_strnstr(s1, s2, n)) == clang_sl((long)strnstr(s1, s2, n)));
			}, @"strncmp('$((string)s1)', '$((string)s2)')");
			return t.msg();
		}
		result += check("t", "", 0);
		result += check("1234", "1235", 3);
		result += check("1234", "1235", 4);
		result += check("1234", "1235", -1);
		result += check("", "", 42);
		result += check("SupraVim", "Supravim", 42);
		result += check("SupraVim", "supravim", 42);
		result += check("SupraVim", "supraVim", 42);
		result += check("SupraVim", "SuprAviM", 42);
		result += check("SupraVim", "SupraVimX", 42);
		result += check("SupraVim", "SupraVi", 42);
		result += check("Sup\0raVime", "Sup\0raVi", 42);
		result += check("", "1", 0);
		result += check("1", "", 0);
		result += check("", "1", 1);
		result += check("1", "", 1);
		result += check("", "", 1);
		return result;
	}
	catch (Error e) {
		return @"$result \033[31m$(e.message)\033[0m";
	}
}

// atoi
delegate int d_atoi(string s);
string run_atoi() {
	string result = "ATOI:     ";
	try {
		var ft_atoi = (d_atoi)loader.symbol("ft_atoi");
		result += Test.complex(2, () => { return (ft_atoi("2147483647") == 2147483647); }, "int MAX").msg();
		result += Test.complex(2, () => { return (ft_atoi("-2147483648") == -2147483648); }, "int MIN").msg();
		result += Test.complex(2, () => { return (ft_atoi("0") == 0); }, "0").msg();
		result += Test.complex(2, () => { return (ft_atoi("1") == 1); }, "1").msg();
		result += Test.complex(2, () => { return (ft_atoi("2") == 2); }, "2").msg();
		result += Test.complex(2, () => { return (ft_atoi("9") == 9); }, "9").msg();
		result += Test.complex(2, () => { return (ft_atoi("10") == 10); }, "10").msg();
		result += Test.complex(2, () => { return (ft_atoi("11") == 11); }, "11").msg();
		result += Test.complex(2, () => { return (ft_atoi("42") == 42); }, "42").msg();
		result += Test.complex(2, () => { return (ft_atoi("-1") == -1); }, "-1").msg();
		result += Test.complex(2, () => { return (ft_atoi("-2") == -2); }, "-2").msg();
		result += Test.complex(2, () => { return (ft_atoi("-9") == -9); }, "-9").msg();
		result += Test.complex(2, () => { return (ft_atoi("-10") == -10); }, "-10").msg();
		result += Test.complex(2, () => { return (ft_atoi("-11") == -11); }, "-11").msg();
		result += Test.complex(2, () => { return (ft_atoi("-42") == -42); }, "-42").msg();
		result += Test.complex(2, () => { return (ft_atoi("165468465") == 165468465); }, "165468465").msg();
		for (int N = 0; N < 5; ++N)
		{
			var i = Random.int_range(int.MIN, int.MAX);
			result += Test.complex(2, () => { return (ft_atoi(@"$i") == i); }, @"random test $i").msg();
		}
		return result;
	}
	catch (Error e) {
		return @"$result \033[31m$(e.message)\033[0m";
	}
}
