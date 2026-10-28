string run_strnstr() {
	string result = "STRNSTR:  ";
	try {
		var ft_strnstr= (d_strnstr)loader.symbol("ft_strnstr");
		string check(char* s1, char* s2, size_t n) {
			return SupraTest.test(null, ()=>{
				char* a = ft_strnstr(s1, s2, n);
				char* b = strnstr(s1, s2, n);
				if (a != b) {
					stderr.printf("strnstr(\"%s\", \"%s\", %ld) you: %s, me: %s ", (string)s1, (string)s2, (long)n, quote((string)a), quote((string)b));
					return false;
				}
				return true;
			}).msg_err();
		}
		/* 1 */  result += check("a", "c'est supra magique", 3);
		/* 2 */  result += check("a", "c'est supra magique", 42);
		/* 3 */  result += check("abc", "zzzzzzzzzzzabczzzzzzzzz", 3);
		/* 4 */  result += check("abc", "zzzzzzzzzzzabczzzzzzzzz", 42);
		/* 5 */  result += check("", "zzzzzzzzzzzabczzzzzzzzz", 42);
		/* 6 */  result += check("", "", 42);
		/* 7 */  result += check("", "", 0);
		/* 8 */  result += check("zzzzzzzzzzzabczzzzzzzzz", "", 42);
		/* 9 */  result += check("supravim est supra bien", "vim", 42);
		/* 10 */  result += check("supravim est supra bien", "vim", 8);
		/* 11 */  result += check("supravim est supra bien", "vim", 7);
		/* 12 */  result += check("supravim est supra bien", "vim", 6);
		/* 13 */  result += check("hello\0world", "world", 42);
		/* 14 */  result += check("lorem ipsum dolor sit amet", "dol", 30);
		/* 15 */  result += check("lorem ipsum dolor sit amet", "consectetur", 30);
		/* 16 */  result += check("lorem ipsum dolor sit amet", "sit", 10);
		/* 17 */  result += check("lorem ipsum dolor sit amet", "dolor", 15);
		/* 18 */  result += check("lorem ipsum dolor sit amet", "dolor", 0);
		// partial match followed by the real one
		/* 19 */  result += check("aaaab", "aaab", 5);
		/* 20 */  result += check("abcabcabd", "abcabd", 9);
		/* 21 */  result += check("bbbbbbbbbbbbbbbc", "bbbc", 16);
		// match ending exactly at len, then one char too far
		/* 22 */  result += check("aaaab", "aaab", 4);
		/* 23 */  result += check("lorem ipsum", "ipsum", 11);
		/* 24 */  result += check("lorem ipsum", "ipsum", 10);
		/* 25 */  result += check("abc", "c", 3);
		/* 26 */  result += check("abc", "c", 2);
		/* 27 */  result += check("needle", "needle", 6);
		/* 28 */  result += check("needle", "needle", 5);
		// little longer than big
		/* 29 */  result += check("abc", "abcd", 10);

		return result;
	}
	catch (Error e) {
		return @"$result \033[31m$(e.message)\033[0m";
	}
}
