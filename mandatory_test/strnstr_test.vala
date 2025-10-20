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
