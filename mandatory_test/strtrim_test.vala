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
