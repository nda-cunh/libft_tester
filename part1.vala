

int clang_s(int n) {
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
		var n = 0;
		for (int i = 0; i < 255; ++i)
		{
			try { Test.simple(2, () => { return (clang_s(ft_isalpha(i)) == clang_s(clang_isalpha(i))); }, i.to_string()); }
			catch (Test.TestValue e) {
				if (e is Test.TestValue.OK)
					++n;
				else
					result += e.message;
			}
		}
		if (n == 255)
			return result + "\033[32m[OK]\033[0m";
		else
			return result;
	}
	catch (Error e) {
		return @"$result \033[31m$(e.message)\033[0m";
	}
}

[CCode (cname = "isdigit", cheader_filename="ctype.h")]
extern int clang_isdigit(int c);
delegate int d_isdigit(int c);
string run_isdigit() {
	string result = "IS_DIGIT: ";
	try {
		var ft_isdigit = (d_isdigit)loader.symbol("ft_isdigit");
		var n = 0;
		for (int i = 0; i < 255; ++i)
		{
			try { Test.simple(2, () => { return (clang_s(ft_isdigit(i)) == clang_s(clang_isdigit(i))); }, i.to_string()); }
			catch (Test.TestValue e) {
				if (e is Test.TestValue.OK)
					++n;
				else
					result += e.message;
			}
		}
		if (n == 255)
			return result + "\033[32m[OK]\033[0m";
		else
			return result;
	}
	catch (Error e) {
		return @"$result \033[31m$(e.message)\033[0m";
	}
}

[CCode (cname = "isalnum", cheader_filename="ctype.h")]
extern int clang_isalnum(int c);
delegate int d_isalnum(int c);
string run_isalnum() {
	string result = "IS_ALNUM: ";
	try {
		var ft_isalnum = (d_isalnum)loader.symbol("ft_isalnum");
		var n = 0;
		for (int i = 0; i < 255; ++i)
		{
			try { Test.simple(2, () => { return (clang_s(ft_isalnum(i)) == clang_s(clang_isalnum(i))); }, i.to_string()); }
			catch (Test.TestValue e) {
				if (e is Test.TestValue.OK)
					++n;
				else
					result += e.message;
			}
		}
		if (n == 255)
			return result + "\033[32m[OK]\033[0m";
		else
			return result;
	}
	catch (Error e) {
		return @"$result \033[31m$(e.message)\033[0m";
	}
}

[CCode (cname = "isascii", cheader_filename="ctype.h")]
extern int clang_isascii(int c);
delegate int d_isascii(int c);
string run_isascii() {
	string result = "IS_ASCII: ";
	try {
		var ft_isascii = (d_isascii)loader.symbol("ft_isascii");
		var n = 0;
		for (int i = 0; i < 255; ++i)
		{
			try { Test.simple(2, () => { return (clang_s(ft_isascii(i)) == clang_s(clang_isascii(i))); }, i.to_string()); }
			catch (Test.TestValue e) {
				if (e is Test.TestValue.OK)
					++n;
				else
					result += e.message;
			}
		}
		if (n == 255)
			return result + "\033[32m[OK]\033[0m";
		else
			return result;
	}
	catch (Error e) {
		return @"$result \033[31m$(e.message)\033[0m";
	}
}

[CCode (cname = "isprint", cheader_filename="ctype.h")]
extern int clang_isprint(int c);
delegate int d_isprint(int c);
string run_isprint() {
	string result = "IS_PRINT: ";
	try {
		var ft_isprint = (d_isprint)loader.symbol("ft_isprint");
		var n = 0;
		for (int i = 0; i < 255; ++i)
		{
			try { Test.simple(2, () => { return (clang_s(ft_isprint(i)) == clang_s(clang_isprint(i))); }, i.to_string()); }
			catch (Test.TestValue e) {
				if (e is Test.TestValue.OK)
					++n;
				else
					result += e.message;
			}
		}
		if (n == 255)
			return result + "\033[32m[OK]\033[0m";
		else
			return result;
	}
	catch (Error e) {
		return @"$result \033[31m$(e.message)\033[0m";
	}
}

delegate int d_strlen(string s);
string run_strlen() {
	string result = "STRLEN: ";
	try {
		var ft_strlen = (d_strlen)loader.symbol("ft_strlen");
		try { Test.memory(2, () => { return (ft_strlen("1") == 1); }, "1"); }catch (Test.TestValue e) { result += e.message; }
		try { Test.memory(2, () => { return (ft_strlen("12") == 2); }, "2"); }catch (Test.TestValue e) { result += e.message; }
		try { Test.memory(2, () => { return (ft_strlen("123") == 3); }, "3"); }catch (Test.TestValue e) { result += e.message; }
		try { Test.memory(2, () => { return (ft_strlen("1234") == 4); }, "4"); }catch (Test.TestValue e) { result += e.message; }
		try { Test.memory(2, () => { return (ft_strlen("12345") == 5); }, "5"); }catch (Test.TestValue e) { result += e.message; }
		try { Test.memory(2, () => { return (ft_strlen("12\0abc") == 2); }, "strlen(12\\0abc)lire au dessus de 0?"); }catch (Test.TestValue e) { result += e.message; }
		try { Test.memory(2, () => { return (ft_strlen("   \t\t\t\r\n") == 8); }, "des espaces"); }catch (Test.TestValue e) { result += e.message; }
		return result;
	}
	catch (Error e) {
		return @"$result \033[31m$(e.message)\033[0m";
	}
}

delegate int d_memset(void* mem, char c, int nb);
string run_memset() {
	string result = "MEMSET: ";
	try {
		var ft_memset = (d_memset)loader.symbol("ft_memset");
		try { Test.memory(2, () => {
			uint8 buf[20];
			ft_memset(buf, 'E', 6);
			buf[6] = '\0';
			return((string)buf == "EEEEEE");
		}, "memset(mem, E, 6)");
		}catch (Test.TestValue e) { result += e.message; }
		try { Test.memory(2, () => {
			uint8 buf[20];
			ft_memset(buf, 'E', 6);
			buf[6] = '\0';
			return(buf[7] != 'E');
		}, "trop loin...");
		}catch (Test.TestValue e) { result += e.message; }
		try { Test.memory(2, () => {
			uint8 buf[20];
			buf[5] = '\0';
			ft_memset(buf, 'E', 6);
			buf[6] = '\0';
			return(buf[5] == 'E');
		}, "pas asser loin...");
		}catch (Test.TestValue e) { result += e.message; }
		try { Test.memory(2, () => {
			uint8 buf[5];
			buf[0] = 'J';
			ft_memset(buf, 'E', 0);
			return(buf[0] == 'J');
		}, "bug avec memset 0");
		}catch (Test.TestValue e) { result += e.message; }
		return result;
	}
	catch (Error e) {
		return @"$result \033[31m$(e.message)\033[0m";
	}
}

delegate int d_bzero(void* mem, int nb);
string run_bzero() {
	string result = "BZERO: ";
	try {
		var ft_bzero = (d_bzero)loader.symbol("ft_bzero");
		for (int i = 0; i < 35; ++i)
		{
			try { Test.memory(2, () => {
				uint8 buf1[40];
				uint8 buf2[40];
				Memory.set(buf1, 'X', 40);
				Memory.set(buf2, 'X', 40);
				
				ft_bzero(buf1, i);
				Memory.set(buf2, '\0', i);
				if (Memory.cmp(buf1, buf2, i) == 0)
					return true; 
				return false;
			}, @"bzero(mem, E, $i)");
			}catch (Test.TestValue e) { result += e.message; }
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
	string result = "TOUPPER: ";
	try {
		var ft_toupper= (d_toupper)loader.symbol("ft_toupper");
		var n = 0;
		for (int i = 0; i < 255; ++i)
		{
			try { Test.memory(2, () => { return (clang_s(ft_toupper(i)) == clang_s(clang_toupper(i))); }, i.to_string()); }
			catch (Test.TestValue e) {
				if (e is Test.TestValue.OK)
					++n;
				else
					result += e.message;
			}
		}
		if (n == 255)
			return result + "\033[32m[OK]\033[0m";
		else
			return result;
	}
	catch (Error e) {
		return @"$result \033[31m$(e.message)\033[0m";
	}
}

[CCode (cname = "tolower", cheader_filename="ctype.h")]
extern int clang_tolower(int c);
delegate int d_tolower(int c);
string run_tolower() {
	string result = "TOLOWER: ";
	try {
		var ft_tolower= (d_tolower)loader.symbol("ft_tolower");
		var n = 0;
		for (int i = 0; i < 255; ++i)
		{
			try { Test.memory(2, () => { return (clang_s(ft_tolower(i)) == clang_s(clang_tolower(i))); }, i.to_string()); }
			catch (Test.TestValue e) {
				if (e is Test.TestValue.OK)
					++n;
				else
					result += e.message;
			}
		}
		if (n == 255)
			return result + "\033[32m[OK]\033[0m";
		else
			return result;
	}
	catch (Error e) {
		return @"$result \033[31m$(e.message)\033[0m";
	}
}


//TODO strchr
[CCode (cname = "strchr", cheader_filename="string.h")]
extern char *strchr(char *s, int c);
delegate char *d_strchr(char *s, int c);
string run_strchr() {
	string result = "STRCHR: ";
	try {
		var ft_strchr = (d_strchr)loader.symbol("ft_strchr");
		
		try { Test.memory(2, () => {
				string s = "suprapatata\0vttiX";
				int c = 's';
				return (strchr(s, c) == ft_strchr(s, c));
		}, """strchr("suprapatata\0vttiX", 's')"""); }
		catch (Test.TestValue e) { result += e.message; }
		try { Test.memory(2, () => {
				string s = "suprapatata\0vttiX";
				int c = 'a';
				return (strchr(s, c) == ft_strchr(s, c));
		}, """strchr("suprapatata\0vttiX", 'a')"""); }
		catch (Test.TestValue e) { result += e.message; }
		try { Test.memory(2, () => {
				string s = "suprapatata\0vttiX";
				int c = 'p';
				return (strchr(s, c) == ft_strchr(s, c));
		}, """strchr("suprapatata\0vttiX", 'a')"""); }
		catch (Test.TestValue e) { result += e.message; }
		try { Test.memory(2, () => {
				string s = "suprapatata\0vttiX";
				int c = 'v';
				return (strchr(s, c) == ft_strchr(s, c));
		}, """strchr("suprapatata\0vttiX", 'v')"""); }
		catch (Test.TestValue e) { result += e.message; }
		try { Test.memory(2, () => {
				string s = "suprapatata\0vttiX";
				int c = 'X';
				return (strchr(s, c) == ft_strchr(s, c));
		}, """strchr("suprapatata\0vttiX", 'X')"""); }
		catch (Test.TestValue e) { result += e.message; }
	}
	catch (Error e) {
		return @"$result \033[31m$(e.message)\033[0m";
	}
	return result;
}


//TODO // strrchr
[CCode (cname = "strrchr", cheader_filename="string.h")]
extern char *strrchr(char *s, int c);
delegate char *d_strrchr(char *s, int c);
string run_strrchr() {
	string result = "STRRCHR: ";
	try {
		var ft_strrchr = (d_strrchr)loader.symbol("ft_strrchr");
		
		try { Test.memory(2, () => {
				string s = "suprapatata\0vttiX";
				int c = 's';
				return (strrchr(s, c) == ft_strrchr(s, c));
		}, """strrchr("suprapatata\0vttiX", 's')"""); }
		catch (Test.TestValue e) { result += e.message; }
		try { Test.memory(2, () => {
				string s = "suprapatata\0vttiX";
				int c = 'a';
				return (strrchr(s, c) == ft_strrchr(s, c));
		}, """strrchr("suprapatata\0vttiX", 'a')"""); }
		catch (Test.TestValue e) { result += e.message; }
		try { Test.memory(2, () => {
				string s = "suprapatata\0vttiX";
				int c = 'p';
				return (strrchr(s, c) == ft_strrchr(s, c));
		}, """strrchr("suprapatata\0vttiX", 'a')"""); }
		catch (Test.TestValue e) { result += e.message; }
		try { Test.memory(2, () => {
				string s = "suprapatata\0vttiX";
				int c = 'v';
				return (strrchr(s, c) == ft_strrchr(s, c));
		}, """strrchr("suprapatata\0vttiX", 'v')"""); }
		catch (Test.TestValue e) { result += e.message; }
		try { Test.memory(2, () => {
				string s = "suprapatata\0vttiX";
				int c = 'X';
				return (strrchr(s, c) == ft_strrchr(s, c));
		}, """strrchr("suprapatata\0vttiX", 'X')"""); }
		catch (Test.TestValue e) { result += e.message; }
	}
	catch (Error e) {
		return @"$result \033[31m$(e.message)\033[0m";
	}
	return result;
}
//TODO // strncmp
//TODO // memchr
//TODO // memcmp
//TODO // strnstr





// atoi
delegate int d_atoi(string s);
string run_atoi() {
	string result = "ATOI: ";
	try {
		var ft_atoi = (d_atoi)loader.symbol("ft_atoi");
		try { Test.memory(2, () => { return (ft_atoi("2147483647") == 2147483647); }, "int MAX"); }catch (Test.TestValue e) { result += e.message; }
		try { Test.memory(2, () => { return (ft_atoi("-2147483648") == -2147483648); }, "int MIN"); }catch (Test.TestValue e) { result += e.message; }
		try { Test.memory(2, () => { return (ft_atoi("0") == 0); }, "0"); }catch (Test.TestValue e) { result += e.message; }
		try { Test.memory(2, () => { return (ft_atoi("1") == 1); }, "1"); }catch (Test.TestValue e) { result += e.message; }
		try { Test.memory(2, () => { return (ft_atoi("2") == 2); }, "2"); }catch (Test.TestValue e) { result += e.message; }
		try { Test.memory(2, () => { return (ft_atoi("9") == 9); }, "9"); }catch (Test.TestValue e) { result += e.message; }
		try { Test.memory(2, () => { return (ft_atoi("10") == 10); }, "10"); }catch (Test.TestValue e) { result += e.message; }
		try { Test.memory(2, () => { return (ft_atoi("11") == 11); }, "11"); }catch (Test.TestValue e) { result += e.message; }
		try { Test.memory(2, () => { return (ft_atoi("42") == 42); }, "42"); }catch (Test.TestValue e) { result += e.message; }
		try { Test.memory(2, () => { return (ft_atoi("-1") == -1); }, "-1"); }catch (Test.TestValue e) { result += e.message; }
		try { Test.memory(2, () => { return (ft_atoi("-2") == -2); }, "-2"); }catch (Test.TestValue e) { result += e.message; }
		try { Test.memory(2, () => { return (ft_atoi("-9") == -9); }, "-9"); }catch (Test.TestValue e) { result += e.message; }
		try { Test.memory(2, () => { return (ft_atoi("-10") == -10); }, "-10"); }catch (Test.TestValue e) { result += e.message; }
		try { Test.memory(2, () => { return (ft_atoi("-11") == -11); }, "-11"); }catch (Test.TestValue e) { result += e.message; }
		try { Test.memory(2, () => { return (ft_atoi("-42") == -42); }, "-42"); }catch (Test.TestValue e) { result += e.message; }
		try { Test.memory(2, () => { return (ft_atoi("165468465") == 165468465); }, "165468465"); }catch (Test.TestValue e) { result += e.message; }
		for (int N = 0; N < 5; ++N)
		{
			try {
				var i = Random.int_range(int.MIN, int.MAX);
				Test.memory(2, () => { return (ft_atoi(@"$i") == i); }, @"random test $i");
			}catch (Test.TestValue e) { result += e.message; }
		}
		return result;
	}
	catch (Error e) {
		return @"$result \033[31m$(e.message)\033[0m";
	}
}
