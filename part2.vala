[CCode (has_target = false)]
delegate string d_itoa(int n);
string run_itoa() {
	string result = "ITOA:     ";
	try {
		var ft_itoa = (d_itoa)loader.symbol("ft_itoa");
		string check(int n, string? msg = null) {
			return SupraTest.test(8, () => {
				return (ft_itoa(n) == @"$n");
			}, msg ?? @"$n").msg();
		}
		/* 1 */ result += check(2147483647, "INT MAX ");
		/* 2 */ result += check(-2147483648, "INT MIN ");
		/* 3 */ result += check(0);
		/* 4 */ result += check(1);
		/* 5 */ result += check(2);
		/* 6 */ result += check(9);
		/* 7 */ result += check(10);
		/* 8 */ result += check(11);
		/* 9 */ result += check(42);
		/* 10 */ result += check(-1);
		/* 11 */ result += check(-2);
		/* 12 */ result += check(-9);
		/* 13 */ result += check(-10);
		/* 14 */ result += check(-11);
		/* 15 */ result += check(-42);
		/* 16 */ result += check(165468465);
		/* 17 */ for (var N = 0; N < 5; ++N)
		{
			var i = Random.int_range(int.MIN, int.MAX);
			result += check(i);
		}
		/* 18 */ result += SupraTest.test(4, ()=>{
			SupraLeak.send_null();
			char *s = ft_itoa(42);
			if (s != null)
				delete s;
			return (s == null);
		}, "no protect ").msg_err();
		return result;
	}
	catch (Error e) {
		return @"$result \033[31m$(e.message)\033[0m";
	}
}

[CCode (has_target = false)]
delegate string d_substr(char *s, uint start, size_t len);
string run_substr() {
	string result = "SUBSTR:   ";
	try {
		var ft_substr = (d_substr)loader.symbol("ft_substr");

		string check(string str, uint start, size_t len, string sp) {
			var t = SupraTest.test(8, () => {
				string? splice = sp; 
				var sp1 = ft_substr(str, start, len);
				if (sp1 == splice)
					return true;
				stderr.printf("[You:'%s' != Me:'%s'] ", sp1, splice); 
				return false;
			});
			return t.msg(@"test: ('$str', $start, $len) $(t.stderr)");
		}

		/* 1 */ result += check("hello salut", 0, 5, "hello");
		/* 2 */ result += check("hello salut", 1, 5, "ello ");
		/* 3 */ result += check("hello salut", 0, 10, "hello salu");
		/* 4 */ result += check("hello salut", 0, 0, "");
		/* 5 */ result += check("hello salut", 5, 5, " salu");
		/* 6 */ result += check("", 0, 5, "");
		/* 7 */ result += check("salut !", 0, int.MAX, "salut !");
		/* 8 */ result += check("salut !", 100, 1, "");
		/* 9 */ result += check("0123456789", 9, 10, "9");
		/* 10 */ result += check("BONJOUR LES HARICOTS !", 8, 14, "LES HARICOTS !");
		/* 11 */ result += SupraTest.test(8, ()=>{
			SupraLeak.send_null();
			char *s = ft_substr("abc", 1, 3);
			if (s != null)
				delete s;
			return (s == null);
		}, "no protect ").msg_err();


		return result;
	}
	catch (Error e) {
		return @"$result \033[31m$(e.message)\033[0m";
	}
}
// ft_strjoin
[CCode (has_target = false)]
delegate string d_strjoin(char *s1, char *s2);
string run_strjoin() {
	string result = "STRJOIN:  ";
	try {
		var ft_strjoin = (d_strjoin)loader.symbol("ft_strjoin");

		string check(string s1, string s2, string cmp) {
			return SupraTest.test(8, () => {
				var s = ft_strjoin(s1, s2);
				if (s == cmp)
					return true;
				stderr.printf("You:'%s' Me:'%s'", s, cmp);
				return false;
			}).msg_err(@"test: ('$s1', $s2) ");
		}

		/* 1 */ result += check("hello ", "salut", "hello salut");
		/* 2 */ result += check("a", "b", "ab");
		/* 3 */ result += check("", "b", "b");
		/* 4 */ result += check("a", "", "a");
		/* 5 */ result += check("", "", "");
		/* 6 */ result += check("lusersupra testu le dartien", "supra test", "lusersupra testu le dartiensupra test");
		/* 7 */ result += check("", "suprluserbu le dartien test", "suprluserbu le dartien test");
		/* 8 */ result += check("luserbu le dartien", "", "luserbu le dartien");
		/* 9 */ result += check("a a a a a a a", "a a a a a a a  a a  a   a a  ", "a a a a a a aa a a a a a a  a a  a   a a  ");
		
		/* 10 */ result += SupraTest.test(8, ()=>{
			SupraLeak.send_null();
			char *s = ft_strjoin("ab", "ab");
			if (s != null)
				delete s;
			return (s == null);
		}, "no protect ").msg_err();
		
		return result;
	}
	catch (Error e) {
		return @"$result \033[31m$(e.message)\033[0m";
	}
}

[CCode (has_target = false)]
delegate string d_strtrim(char *s1, char *set);
string run_strtrim() {
	string result = "STRTRIM:  ";
	try {
		var ft_strtrim = (d_strtrim)loader.symbol("ft_strtrim");

		string check(string s1, string s2, string cmp) {
			return SupraTest.test(8, () => {
				var s = ft_strtrim(s1, s2);
				if (s == cmp)
					return true;
				stderr.printf("You:'%s' Me:'%s'", s, cmp);
				return false;
			}).msg_err(@"test: ('$s1', $s2) ");
		}

		/* 1 */ result += check("hello salut", "salut", "hello ");
		/* 2 */ result += check("abracadabra", "a", "bracadabr");
		/* 3 */ result += check("aaaaaaaaaaaaaaaa", "a", "");
		/* 4 */ result += check("", "123", "");
		/* 5 */ result += check("", "", "");
		/* 6 */ result += check("123", "", "123");
		/* 7 */ result += check(" bcadsalutbacddcdc  ", "ab cd", "salut");
		/* 8 */ result += check("nabila: 2x2=4 ? non 2+2 = 4! je pense qu'il se sont trompe", "ab:cde'fghijklmnopq rstuvwxyz", "2x2=4 ? non 2+2 = 4!");
		/* 9 */ result += check("   xxx   xxx", " x", "");
		/* 10 */ result += check("abcdba", "acb", "d");
		/* 11 */ result += check("      supra         ", "      ", "supra");
		/* 12 */ result += check("      sup  ra         ", "      ", "sup  ra");
		
		/* 13 */ result += SupraTest.test(8, ()=>{
			SupraLeak.send_null();
			char *s = ft_strtrim("ab", "ab");
			if (s != null)
				delete s;
			return (s == null);
		}, "no protect ").msg_err();
		
		return result;
	}
	catch (Error e) {
		return @"$result \033[31m$(e.message)\033[0m";
	}
}

[CCode (has_target = false)]
delegate char** d_split(char *s, char c);
string run_split() {
	string result = "SPLIT:    ";
	try {
		var ft_split = (d_split)loader.symbol("ft_split");

		string check(string str, char c, string []cmp) {
			return SupraTest.test(8, () => {
				var sp1 = ft_split(str, c);
			
				for (int i = 0; sp1[i] != null; ++i)
				{
					if ((string)sp1[i] != cmp[i]) {
						stderr.printf("You: [");
						for (int e = 0; sp1[e] != null; ++e) {
							stderr.printf("'%s',", (string)sp1[e]);
						}
						stderr.printf("(null)] Me: [");
						foreach (var e in cmp) {
							stderr.printf("'%s',", e);
						}
						stderr.printf("(null)]");
						for (int j = 0; sp1[j] != null; ++j)
							free(sp1[j]);
						free(sp1);
						return false;
					}
				}
				for (int j = 0; sp1[j] != null; ++j)
					free(sp1[j]);
				free(sp1);
				return true;
			}).msg_err(@"split(\"$str\", '$c')");
		}

		/* 1 */ result += check("a,a,a,a", ',', {"a", "a", "a", "a"});
		/* 2 */ result += check("", ',', {""});
		/* 3 */ result += check("a", ',', {"a"});
		/* 4 */ result += check(",a", ',', {"a"});
		/* 5 */ result += check("a,", ',', {"a"});
		/* 6 */ result += check(",a,", ',', {"a"});
		/* 7 */ result += check("salut", ',', {"salut"});
		/* 8 */ result += check(",salut", ',', {"salut"});
		/* 9 */ result += check("salut,", ',', {"salut"});
		/* 10 */ result += check(",salut,", ',', {"salut"});
		/* 11 */ result += check("--1-2--3---4----5-----42", '-', {"1", "2", "3", "4", "5", "42"});
		/* 12 */ result += check(",", ',', {""});
		/* 13 */ result += check(",,", ',', {""});
		/* 14 */ result += check(",,,", ',', {""});
		/* 15 */ result += check(",,,", '\0', {",,,"});
		/* 16 */ result += check(" ", ',', {" "});
		/* 17 */ result += SupraTest.test(8, ()=>{
			SupraLeak.send_null();
			char **s = ft_split("bababababhc", 'a');
			if (s != null)
				delete s;
			return (s == null);
		}, "no protect ").msg_err();

		return result;
	}
	catch (Error e) {
		return @"$result \033[31m$(e.message)\033[0m";
	}
}

// ft_strmapi

[CCode (has_target = false)]
delegate char d_param_strmapi(uint n, char c);
[CCode (has_target = false)]
delegate string d_strmapi(char *s, d_param_strmapi func);
string run_strmapi() {
	string result = "STRMAPI:  ";
	try {
		var ft_strmapi = (d_strmapi)loader.symbol("ft_strmapi");

		string check(string s1, d_param_strmapi func, string cmp) {
			return SupraTest.test(8, () => {
				var s = ft_strmapi(s1, func);
				if (s == cmp)
					return true;
				stderr.printf("You:'%s' Me:'%s'", (string)s, cmp);
				return false;
			}).msg_err("");
		}

		/* 1 */ result += check("salut", (n, c)=>{
				return 'e'; 
			}, "eeeee");
		/* 2 */ result += check("abcde", (n, c)=>{
				return c + 1; 
			}, "bcdef");
		/* 3 */ result += check("chocolat", (n, c)=>{
				if (n % 2 == 0)
					return c;
				return c - 32; 
			}, "cHoCoLaT");
		/* 4 */ result += check("chocolat", (n, c)=>{
				if (n == 3 || n == 5)
					return c - 32; 
				return c;
			}, "choCoLat");
		/* 5 */ result += SupraTest.test(8, ()=>{
			SupraLeak.send_null();
			char *s = ft_strmapi("abc", ()=>{return 'e';});
			return (s == null);
		}, "no protect ").msg_err();
			
		return result;
	}
	catch (Error e) {
		return @"$result \033[31m$(e.message)\033[0m";
	}
}
// ft_striteri

[CCode (has_target = false)]
delegate void d_param_striteri(uint n, char *s);
[CCode (has_target = false)]
delegate void d_striteri(char *s, d_param_striteri func);
string run_striteri() {
	string result = "STRITERI: ";
	try {
		var ft_striteri = (d_striteri)loader.symbol("ft_striteri");

		string check(string s1, d_param_striteri func, string cmp) {
			return SupraTest.test(8, () => {
				ft_striteri(s1, func);
				if (s1 == cmp)
					return true;
				stderr.printf("You:'%s' Me:'%s'", s1, cmp);
				return false;
			}).msg_err("");
		}

		/* 1 */ result += check("salut", (n, s)=>{
				s[0] = 'e';
			}, "eeeee");
		/* 2 */ result += check("abcde", (n, s)=>{
				s[0] = s[0] + 1;
			}, "bcdef");
		/* 3 */ result += check("chocolat", (n, s)=>{
				if (n % 2 != 0)
					s[0] = s[0] - 32;
			}, "cHoCoLaT");
		/* 4 */ result += check("chocolat", (n, s)=>{
				if (n == 3 || n == 5)
					s[0] = s[0] - 32;
			}, "choCoLat");
		/* 5 */ result += check("chocolat", (n, s)=>{
				if (n == 0){
					s[1] = 'V';
					s[3] = 'V';
				}
				if (n == 5){
					s[-1] = 'h';
				}
			}, "cVoVhlat");
		return result;
	}
	catch (Error e) {
		return @"$result \033[31m$(e.message)\033[0m";
	}
}


[CCode (has_target = false)]
delegate void d_putchar_fd(char c, int fd);
string run_putchar_fd() {
	string result = "PUTCHARFD:";
	try {
		var ft_putchar_fd = (d_putchar_fd)loader.symbol("ft_putchar_fd");
		SupraTest.Test t;
		//test 1
		t = SupraTest.complex(8, () => {
			ft_putchar_fd('e', 1);
			return true;
		});
		if (t.status == OK && t.stdout == "e" && t.stderr == "")
			t.status = OK;
		result += t.msg(@"putchar('e', 1) you '$(t.stdout)' ");
		
		//test 2
		
		t = SupraTest.complex(8, () => {
			ft_putchar_fd('v', 2);
			return true;
		});
		if (t.status == OK && t.stdout == "" && t.stderr == "v")
			t.status = OK;
		result += t.msg(@"putchar('e', 2) you '$(t.stderr)' ");
		
		//test 3
		
		t = SupraTest.complex(8, () => {
			ft_putchar_fd('e', -1);
			return true;
		});
		if (t.status == OK && t.stdout == "" && t.stderr == "")
			t.status = OK;
		result += t.msg(@"putchar('e', -1) you '$(t.stderr)' ");

		return result;
	}
	catch (Error e) {
		return @"$result \033[31m$(e.message)\033[0m";
	}
}

[CCode (has_target = false)]
delegate void d_putstr_fd(char *s, int fd);
string run_putstr_fd() {
	string result = "PUTSTRFD: ";
	try {
		var ft_putstr_fd = (d_putstr_fd)loader.symbol("ft_putstr_fd");
		string check(string s, int fd) {
			var t = SupraTest.complex(8, () => {
				ft_putstr_fd(s, fd);
				return false;
			});
			if (t.status == KO) {
				if (fd == 1 && t.stdout == s && t.stderr == "") {
					t.status = OK;
					return t.msg(@"putstr('$s', 1) you '$(t.stdout)' ");
				} else if (fd == -1 && t.stdout == "" && t.stderr == "") {
					t.status = OK;
					return t.msg(@"putstr('$s', 1) you '$(t.stdout)' ");
				} else if (fd != -1 && t.stdout == "" && t.stderr == s) {
					t.status = OK;
					return t.msg(@"putstr('$s', 2) you '$(t.stderr)' ");
				}
			}
			return t.msg(@"putstr('$s', $fd) ");
		}
		result += check("abc", 1);
		result += check("abc", 2);
		result += check(" \f\r\n\t\v", 1);
		result += check(" \f\r\n\t\v", 2);
		result += check("abcdefghijklmnopqrstuvwxyz", 1);
		result += check("abcdefghijklmnopqrstuvwxyz", 2);
		result += check("v", 1);
		result += check("v", 2);
		result += check("please dont write", -1);
		result += check("", -1);
		result += check("", 1);
		result += check("", 2);
		return result;
	}
	catch (Error e) {
		return @"$result \033[31m$(e.message)\033[0m";
	}
}

[CCode (has_target = false)]
delegate void d_putendl_fd(char *s, int fd);
string run_putendl_fd() {
	string result = "PUTENDLFD:";
	try {
		var ft_putendl_fd = (d_putendl_fd)loader.symbol("ft_putendl_fd");
		string check(string s, int fd) {
			var t = SupraTest.complex(8, () => {
				ft_putendl_fd(s, fd);
				return false;
			});
			if (t.status == KO) {
				if (fd == 1 && t.stdout == @"$s\n" && t.stderr == "") {
					t.status = OK;
					return t.msg(@"putstr('$s', 1) you '$(t.stdout)' ");
				} else if (fd == -1 && t.stdout == "" && t.stderr == "") {
					t.status = OK;
					return t.msg(@"putstr('$s', 1) you '$(t.stdout)' ");
				} else if (fd != -1 && t.stdout == "" && t.stderr == @"$s\n") {
					t.status = OK;
					return t.msg(@"putstr('$s', 2) you '$(t.stderr)' ");
				}
			}
			return t.msg(@"putstr('$s', $fd) ");
		}
		result += check("abc", 1);
		result += check("abc", 2);
		result += check(" \f\r\n\t\v", 1);
		result += check(" \f\r\n\t\v", 2);
		result += check("abcdefghijklmnopqrstuvwxyz", 1);
		result += check("abcdefghijklmnopqrstuvwxyz", 2);
		result += check("v", 1);
		result += check("v", 2);
		result += check("please dont write", -1);
		result += check("", -1);
		result += check("", 1);
		result += check("", 2);
		return result;
	}
	catch (Error e) {
		return @"$result \033[31m$(e.message)\033[0m";
	}
}

[CCode (has_target = false)]
delegate void d_putnbr_fd(int n, int fd);
string run_putnbr_fd() {
	string result = "PUTNBRFD: ";
	try {
		var ft_putnbr_fd = (d_putnbr_fd)loader.symbol("ft_putnbr_fd");
		string check(int s, int fd) {
			var t = SupraTest.complex(8, () => {
				ft_putnbr_fd(s, fd);
				return false;
			});
			if (t.status == KO) {
				if (fd == 1 && t.stdout == @"$s" && t.stderr == "") {
					t.status = OK;
					return t.msg(@"putstr('$s', 1) you '$(t.stdout)' ");
				} else if (fd == -1 && t.stdout == "" && t.stderr == "") {
					t.status = OK;
					return t.msg(@"putstr('$s', 1) you '$(t.stdout)' ");
				} else if (fd != -1 && t.stdout == "" && t.stderr == @"$s") {
					t.status = OK;
					return t.msg(@"putstr('$s', 2) you '$(t.stderr)' ");
				}
			}
			return t.msg(@"putstr('$s', $fd) ");
		}
		for (int i = 1; i != 3; ++i)
		{
			result += check(-42, i);
			result += check(-11, i);
			result += check(-10, i);
			result += check(-9, i);
			result += check(-1, i);
			result += check(0, i);
			result += check(1, i);
			result += check(9, i);
			result += check(10, i);
			result += check(11, i);
			result += check(42, i);
		}
		result += check(0, -1);
		result += check(42, -1);
		return result;
	}
	catch (Error e) {
		return @"$result \033[31m$(e.message)\033[0m";
	}
}
