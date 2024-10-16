delegate char*	d_substr(char *s, uint start, size_t len);
delegate string	d_strjoin(char *s1, char *s2);
delegate char*	d_strtrim(char *s1, char *set);
delegate string	d_itoa(int n);

delegate char	d_param_strmapi(uint n, char c);
delegate string	d_strmapi(char *s, d_param_strmapi f);
delegate void	d_param_striteri(uint n, char *s);
delegate void	d_striteri(char *s, d_param_striteri f);

delegate void	d_putchar_fd(char c, int fd);
delegate void	d_putendl_fd(char *s, int fd);
delegate void	d_putnbr_fd(int n, int fd);
delegate void	d_putstr_fd(char *s, int fd);
delegate char** d_split(char *s, char c);



string run_itoa() {
	var result = new StringBuilder.sized(250);
	result.append("ITOA:     ");
	try {
		var ft_itoa = (d_itoa)loader.symbol("ft_itoa");
		string check(int n, string? msg = null) {
			return SupraTest.test(null, () => {
				return (ft_itoa(n) == @"$n");
			}, msg ?? @"$n").msg();
		}
		/* 1 */ result.append(check(2147483647, "INT MAX "));
		/* 2 */ result.append(check(-2147483648, "INT MIN "));
		/* 3 */ result.append(check(0));
		/* 4 */ result.append(check(1));
		/* 5 */ result.append(check(2));
		/* 6 */ result.append(check(9));
		/* 7 */ result.append(check(10));
		/* 8 */ result.append(check(11));
		/* 9 */ result.append(check(42));
		/* 10 */ result.append(check(-1));
		/* 11 */ result.append(check(-2));
		/* 12 */ result.append(check(-9));
		/* 13 */ result.append(check(-10));
		/* 14 */ result.append(check(-11));
		/* 15 */ result.append(check(-42));
		/* 16 */ result.append(check(1654665));
		/* 17 */ result.append(check(14698465));
		/* 18 */ result.append(check(-16465));
		/* 19 */ result.append(check(546465));
		/* 20 */ result.append(check(-164465));
		/* 21 */ result.append(check(684));
		/* 22 */ result.append(check(-68465));
		/* 23 */ result.append(check(6851465));
		/* 24 */
		result.append(SupraTest.test(null, ()=>{
			SupraLeak.send_null();
			char *s = ft_itoa(42);
			if (s != null)
				delete s;
			return (s == null);
		}, "no protect ").msg_err());
		return (owned)result.str;
	}
	catch (Error e) {
		return @"$(result.str) \033[31m$(e.message)\033[0m";
	}
}

string run_substr() {
	var result = new StringBuilder.sized(250);
	result.append("SUBSTR:   ");
	try {
		var ft_substr = (d_substr)loader.symbol("ft_substr");

		string check(string str, uint start, size_t len, string sp) {

			var t = SupraTest.test(null, () => {
				char *sp1 = ft_substr(str, start, len);
				if (sp1 != null) {
					if (((string)sp1).ascii_casecmp(sp) == 0) {
						free(sp1);
						return true;
					}
				}
				stderr.printf("[You:'%s' != Me:'%s'] ", ((string)sp1).compress(), sp);
				free(sp1);
				return false;
			});


			return t.msg(@"test: ('$str', $start, $len) $(t.stderr)");
		}

		/* 1 */ result.append(check("hello salut", 0, 5, "hello"));
		/* 2 */ result.append(check("hello salut", 1, 5, "ello "));
		/* 3 */ result.append(check("hello salut", 0, 10, "hello salu"));
		/* 4 */ result.append(check("hello salut", 0, 0, ""));
		/* 5 */ result.append(check("hello salut", 5, 5, " salu"));
		/* 6 */ result.append(check("", 0, 5, ""));
		/* 7 */ result.append(check("salut !", 0, int.MAX, "salut !"));
		/* 8 */ result.append(check("salut !", 100, 1, ""));
		/* 9 */ result.append(check("0123456789", 9, 10, "9"));
		/* 10 */ result.append(check("BONJOUR LES HARICOTS !", 8, 14, "LES HARICOTS !"));
		/* 11 */ result.append(check("lorem ipsum dolor sit amet", 0, 10, "lorem ipsu"));
		/* 12 */ result.append(check("lorem ipsum dolor sit amet", 7, 10, "psum dolor"));
		/* 13 */ result.append(check("lorem ipsum dolor sit amet", 7, 0, ""));
		/* 14 */ result.append(check("lorem ipsum dolor sit amet", 40000, 20, ""));
		/* 15 */ result.append(check("lorem ipsum dolor sit amet", 400, 20, ""));

		/* 16 */ result.append(SupraTest.test(null, ()=>{
			SupraLeak.send_null();
			char *s = ft_substr("abc", 1, 3);
			if (s != null)
				delete s;
			return (s == null);
		}, "no protect ").msg_err());
		/* 17 */ result.append(SupraTest.test(null, ()=>{
			SupraLeak.send_null();
			char *s = ft_substr("abc", 5, 3);
			if (s != null)
				delete s;
			return (s == null);
		}, "no protect ").msg_err());

		return (owned)result.str;
	}
	catch (Error e) {
		return @"$(result.str) \033[31m$(e.message)\033[0m";
	}
}
// ft_strjoin

string run_strjoin() {
	var result = new StringBuilder.sized(250);
	result.append("STRJOIN:  ");
	try {
		var ft_strjoin = (d_strjoin)loader.symbol("ft_strjoin");

		string check(string s1, string s2, string cmp) {
			return SupraTest.test(null, () => {
				var s = ft_strjoin(s1, s2);
				if (s == cmp)
					return true;
				stderr.printf("You:'%s' Me:'%s'", (string)s ?? "(null)", cmp);
				return false;
			}).msg_err(@"test: ('$s1', $s2) ");
		}

		/* 1 */ result.append(check("hello ", "salut", "hello salut"));
		/* 2 */ result.append(check("a", "b", "ab"));
		/* 3 */ result.append(check("", "b", "b"));
		/* 4 */ result.append(check("a", "", "a"));
		/* 5 */ result.append(check("", "", ""));
		/* 6 */ result.append(check("lusersupra testu le dartien", "supra test", "lusersupra testu le dartiensupra test"));
		/* 7 */ result.append(check("", "suprluserbu le dartien test", "suprluserbu le dartien test"));
		/* 8 */ result.append(check("luserbu le dartien", "", "luserbu le dartien"));
		/* 9 */ result.append(check("a a a a a a a", "a a a a a a a  a a  a   a a  ", "a a a a a a aa a a a a a a  a a  a   a a  "));

		/* 10 */ result.append(SupraTest.test(null, ()=>{
			SupraLeak.send_null();
			char *s = ft_strjoin("ab", "ab");
			if (s != null)
				delete s;
			return (s == null);
		}, "no protect ").msg_err());

		return (owned)result.str;
	}
	catch (Error e) {
		return @"$(result.str) \033[31m$(e.message)\033[0m";
	}
}


string run_strtrim() {
	var result = new StringBuilder.sized(250);
	result.append("STRTRIM:  ");
	try {
		var ft_strtrim = (d_strtrim)loader.symbol("ft_strtrim");

		string check(string? s1, string? s2, string? cmp) {
			return SupraTest.test(null, () => {
				char *s = ft_strtrim(s1, s2);
				if (s == null) {
					return (cmp == null);
				}
				if ((string)s == cmp) {
					free(s);
					return true;
				}
				stderr.printf("You:'%s' Me:'%s'", (string)s, cmp);
				free(s);
				return false;
			}).msg_err("strtrim('%s', %s) ".printf(s1 ?? "(null)", s2 ?? "(null)"));
		}

		/* 1 */ result.append(check("hello salut", "salut", "hello "));
		/* 2 */ result.append(check("abracadabra", "a", "bracadabr"));
		/* 3 */ result.append(check("aaaaaaaaaaaaaaaa", "a", ""));
		/* 4 */ result.append(check("", "123", ""));
		/* 5 */ result.append(check("", "", ""));
		/* 6 */ result.append(check("123", "", "123"));
		/* 7 */ result.append(check(" bcadsalutbacddcdc  ", "ab cd", "salut"));
		/* 8 */ result.append(check("nabila: 2x2=4 ? non 2+2 = 4! je pense qu'il se sont trompe", "ab:cde'fghijklmnopq rstuvwxyz", "2x2=4 ? non 2+2 = 4!"));
		/* 9 */ result.append(check("   xxx   xxx", " x", ""));
		/* 10 */ result.append(check("abcdba", "acb", "d"));
		/* 11 */ result.append(check("      supra         ", "      ", "supra"));
		/* 12 */ result.append(check("      sup  ra         ", "      ", "sup  ra"));

		/* 13 */ result.append(check("lorem \n ipsum \t dolor \n sit \t amet", " ", "lorem \n ipsum \t dolor \n sit \t amet"));
		/* 14 */ result.append(check("lorem ipsum dolor sit amet", "te", "lorem ipsum dolor sit am"));
		/* 15 */ result.append(check(" lorem ipsum dolor sit amet", "1 ", "lorem ipsum dolor sit amet"));
		/* 16 */ result.append(check("lorem ipsum dolor sit amet", "tel", "orem ipsum dolor sit am"));
		/* 17 */ result.append(check("          ", " ", ""));
		/* 18 */ result.append(check("          ", "          ", ""));
		/* 19 */ result.append(check(null, null, null));
		/* 20 */ result.append(check("a", null, null));
		/* 21 */ result.append(check("", null, null));
		/* 22 */ result.append(check(null, "", null));
		/* 23 */ result.append(check(null, "abc", null));

		/* 24 */ result.append(SupraTest.test(null, ()=>{
			SupraLeak.send_null();
			char *s = ft_strtrim("ab", "ab");
			if (s != null) {
				delete s;
				return false;
			}
			return (true);
		}, "no protect ").msg_err());

		return (owned)result.str;
	}
	catch (Error e) {
		return @"$(result.str) \033[31m$(e.message)\033[0m";
	}
}


string run_split() {
	var result = new StringBuilder.sized(250);
	result.append("SPLIT:    ");
	try {
		var ft_split = (d_split)loader.symbol("ft_split");

		string check(string str, char c, string? []cmp) {

			void free_print(char **sp, string []cmp, bool printing) {
				if (printing) {
					stderr.printf("Me: [ ");
					foreach (unowned var i in cmp) {
						stderr.printf("\"%s\" ", i);
					}
					stderr.printf("] ");
					stderr.printf("You: [ ");
					int j = 0;
					foreach (unowned var i in cmp) {
						if (sp[j] == null) {
							stderr.printf("\"(null)\"");
							break;
						}
						stderr.printf("\"%s\" ", (string)sp[j]);
						j++;
					}

					stderr.printf("]");
					stderr.printf("\n");
				}
				if (sp != null) {
					strfreev((string[])sp);
				}
			}
			var t = SupraTest.test(null, () => {
				var sp = ft_split(str, c);
				// test if cmp is null
				if (cmp == null) {
					if (sp != null)
						free_print(sp, cmp, false);
					else
						return true;
				}
				int j = 0;
				foreach (unowned var i in cmp) {
					if ((string)sp[j] != i){
						free_print(sp, cmp, true);
						return false;
					}
					j++;
				}

				free_print(sp, cmp, false);
				return true;
			});
			var msg = t.msg_err(@"split(\"$str\", '$c')");
			if (t.status == SIGSEGV)
				msg += "\033[91mme: [" + string.joinv(" ", cmp) + "]\n";
			return msg;
		}

		/* 1 */ result.append(check("a,a,a,a", ',', {"a", "a", "a", "a"}));
		/* 2 */ result.append(check("", ',', {null}));
		/* 3 */ result.append(check("a", ',', {"a"}));
		/* 4 */ result.append(check(",a", ',', {"a"}));
		/* 5 */ result.append(check("a,", ',', {"a"}));
		/* 6 */ result.append(check(",a,", ',', {"a"}));
		/* 7 */ result.append(check("salut", ',', {"salut"}));
		/* 8 */ result.append(check(",salut", ',', {"salut"}));
		/* 9 */ result.append(check("salut,", ',', {"salut"}));
		/* 10 */ result.append(check(",salut,", ',', {"salut"}));
		/* 11 */ result.append(check("--1-2--3---4----5-----42", '-', {"1", "2", "3", "4", "5", "42"}));
		/* 12 */ result.append(check(",", ',', {null}));
		/* 13 */ result.append(check(",,", ',', {null}));
		/* 14 */ result.append(check(",,,", ',', {null}));
		/* 15 */ result.append(check(",,,", '\0', {",,,"}));
		/* 16 */ result.append(check(" ", ',', {" "}));
		/* 16 */ result.append(check("          ", ' ', {null}));

		/* 16 */ result.append(check("lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed non risus. Suspendisse", ' ',
		{"lorem","ipsum","dolor","sit","amet,","consectetur","adipiscing","elit.","Sed","non","risus.","Suspendisse"}));
		/* 16 */ result.append(check("   lorem   ipsum dolor     sit amet, consectetur   adipiscing elit. Sed non risus. Suspendisse  ", ' ',
{"lorem","ipsum","dolor","sit","amet,","consectetur","adipiscing","elit.","Sed","non","risus.","Suspendisse"}));
		/* 16 */ result.append(check("lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed non risus. Suspendisse lectus tortor, dignissim sit amet, adipiscing nec, ultricies sed, dolor. Cras elementum ultricies diam. Maecenas ligula massa, varius a, semper congue, euismod non, mi.", 'i',
{"lorem ","psum dolor s","t amet, consectetur ad","p","sc","ng el","t. Sed non r","sus. Suspend","sse lectus tortor, d","gn","ss","m s","t amet, ad","p","sc","ng nec, ultr","c","es sed, dolor. Cras elementum ultr","c","es d","am. Maecenas l","gula massa, var","us a, semper congue, eu","smod non, m","."}));
		/* 16 */ result.append(check("lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed non risus. Suspendisse lectus tortor, dignissim sit amet, adipiscing nec, ultricies sed, dolor. Cras elementum ultricies diam. Maecenas ligula massa, varius a, semper congue, euismod non, mi.", 'z',
{"lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed non risus. Suspendisse lectus tortor, dignissim sit amet, adipiscing nec, ultricies sed, dolor. Cras elementum ultricies diam. Maecenas ligula massa, varius a, semper congue, euismod non, mi."}));
		/* 16 */ result.append(check("", 'z', {null}));

		/* 17 */ result.append(SupraTest.test(null, ()=>{
			SupraLeak.send_null();
			char **s = ft_split("bababababhc", 'a');
			if (s != null)
				delete s;
			return (s == null);
		}, "no protect ").msg_err());

		return (owned)result.str;
	}
	catch (Error e) {
		return @"$(result.str) \033[31m$(e.message)\033[0m";
	}
}

// ft_strmapi


string run_strmapi() {
	var result = new StringBuilder.sized(250);
	result.append("STRMAPI:  ");
	try {
		var ft_strmapi = (d_strmapi)loader.symbol("ft_strmapi");

		string check(string s1, d_param_strmapi func, string cmp) {
			return SupraTest.test(null, () => {
				var s = ft_strmapi(s1, func);
				if (s == cmp)
					return true;
				stderr.printf("You:'%s' Me:'%s'", (string)s, cmp);
				return false;
			}).msg_err("");
		}

		/* 1 */ result.append(check("salut", (n, c)=>{
				return 'e';
			}, "eeeee"));
		/* 2 */ result.append(check("abcde", (n, c)=>{
				return c + 1;
			}, "bcdef"));
		/* 3 */ result.append(check("chocolat", (n, c)=>{
				if (n % 2 == 0)
					return c;
				return c - 32;
			}, "cHoCoLaT"));
		/* 4 */ result.append(check("chocolat", (n, c)=>{
				if (n == 3 || n == 5)
					return c - 32;
				return c;
			}, "choCoLat"));
		/* 5 */ result.append(SupraTest.test(null, ()=>{
			SupraLeak.send_null();
			char *s = ft_strmapi("abc", ()=>{return 'e';});
			return (s == null);
		}, "no protect ").msg_err());

		return (owned)result.str;
	}
	catch (Error e) {
		return @"$(result.str) \033[31m$(e.message)\033[0m";
	}
}
// ft_striteri



string run_striteri() {
	var result = new StringBuilder.sized(250);
	result.append("STRITERI: ");
	try {
		var ft_striteri = (d_striteri)loader.symbol("ft_striteri");

		string check(string s1, d_param_striteri func, string cmp) {
			return SupraTest.test(null, () => {
				ft_striteri(s1, func);
				if (s1 == cmp)
					return true;
				stderr.printf("You:'%s' Me:'%s'", s1, cmp);
				return false;
			}).msg_err("");
		}

		/* 1 */ result.append(check("salut", (n, s)=>{
				s[0] = 'e';
			}, "eeeee"));
		/* 2 */ result.append(check("abcde", (n, s)=>{
				s[0] = s[0] + 1;
			}, "bcdef"));
		/* 3 */ result.append(check("chocolat", (n, s)=>{
				if (n % 2 != 0)
					s[0] = s[0] - 32;
			}, "cHoCoLaT"));
		/* 4 */ result.append(check("chocolat", (n, s)=>{
				if (n == 3 || n == 5)
					s[0] = s[0] - 32;
			}, "choCoLat"));
		/* 5 */ result.append(check("chocolat", (n, s)=>{
				if (n == 0){
					s[1] = 'V';
					s[3] = 'V';
				}
				if (n == 5){
					s[-1] = 'h';
				}
			}, "cVoVhlat"));
		return (owned)result.str;
	}
	catch (Error e) {
		return @"$(result.str) \033[31m$(e.message)\033[0m";
	}
}



string run_putchar_fd() {
	var result = new StringBuilder.sized(250);
	result.append("PUTCHARFD:");
	try {
		var ft_putchar_fd = (d_putchar_fd)loader.symbol("ft_putchar_fd");
		SupraTest.Test t;
		//test 1
		t = SupraTest.complex(3, () => {
			ft_putchar_fd('e', 1);
			return true;
		});
		if (t.status == OK && t.stdout == "e" && t.stderr == "")
			t.status = OK;
		result.append(t.msg(@"putchar('e', 1) you '$(t.stdout)' "));

		//test 2

		t = SupraTest.complex(3, () => {
			ft_putchar_fd('v', 2);
			return true;
		});
		if (t.status == OK && t.stdout == "" && t.stderr == "v")
			t.status = OK;
		result.append(t.msg(@"putchar('e', 2) you '$(t.stderr)' "));

		//test 3

		t = SupraTest.complex(3, () => {
			ft_putchar_fd('e', -1);
			return true;
		});
		if (t.status == OK && t.stdout == "" && t.stderr == "")
			t.status = OK;
		result.append(t.msg(@"putchar('e', -1) you '$(t.stderr)' "));

		return (owned)result.str;
	}
	catch (Error e) {
		return @"$(result.str) \033[31m$(e.message)\033[0m";
	}
}


string run_putstr_fd() {
	var result = new StringBuilder.sized(250);
	result.append("PUTSTRFD: ");
	try {
		var ft_putstr_fd = (d_putstr_fd)loader.symbol("ft_putstr_fd");
		string check(string s, int fd) {
			var t = SupraTest.complex(3, () => {
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
		result.append(check("abc", 1));
		result.append(check("abc", 2));
		result.append(check(" \f\r\n\t\v", 1));
		result.append(check(" \f\r\n\t\v", 2));
		result.append(check("abcdefghijklmnopqrstuvwxyz", 1));
		result.append(check("abcdefghijklmnopqrstuvwxyz", 2));
		result.append(check("v", 1));
		result.append(check("v", 2));
		result.append(check("please dont write", -1));
		result.append(check("", -1));
		result.append(check("", 1));
		result.append(check("", 2));
		return (owned)result.str;
	}
	catch (Error e) {
		return @"$(result.str) \033[31m$(e.message)\033[0m";
	}
}


string run_putendl_fd() {
	var result = new StringBuilder.sized(250);
	result.append("PUTENDLFD:");
	try {
		var ft_putendl_fd = (d_putendl_fd)loader.symbol("ft_putendl_fd");
		string check(string s, int fd) {
			var t = SupraTest.complex(3, () => {
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
		result.append(check("abc", 1));
		result.append(check("abc", 2));
		result.append(check(" \f\r\n\t\v", 1));
		result.append(check(" \f\r\n\t\v", 2));
		result.append(check("abcdefghijklmnopqrstuvwxyz", 1));
		result.append(check("abcdefghijklmnopqrstuvwxyz", 2));
		result.append(check("v", 1));
		result.append(check("v", 2));
		result.append(check("please dont write", -1));
		result.append(check("", -1));
		result.append(check("", 1));
		result.append(check("", 2));
		return (owned)result.str;
	}
	catch (Error e) {
		return @"$(result.str) \033[31m$(e.message)\033[0m";
	}
}


string run_putnbr_fd() {
	var result = new StringBuilder.sized(250);
	result.append("PUTNBRFD: ");
	try {
		var ft_putnbr_fd = (d_putnbr_fd)loader.symbol("ft_putnbr_fd");
		string check(int s, int fd) {
			var t = SupraTest.complex(3, () => {
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
			result.append(check(-42, i));
			result.append(check(-11, i));
			result.append(check(-10, i));
			result.append(check(-9, i));
			result.append(check(-1, i));
			result.append(check(0, i));
			result.append(check(1, i));
			result.append(check(9, i));
			result.append(check(10, i));
			result.append(check(11, i));
			result.append(check(42, i));
		}
		result.append(check(0, -1));
		result.append(check(42, -1));
		return (owned)result.str;
	}
	catch (Error e) {
		return @"$(result.str) \033[31m$(e.message)\033[0m";
	}
}
