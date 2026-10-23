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
				// garbage after dest: a missing '\0' or a write past n is visible
				Memory.set(d1, 'X', 60); d1[60] = '\0'; Memory.copy(d1, dest, dest.length + 1);
				Memory.set(d2, 'X', 60); d2[60] = '\0'; Memory.copy(d2, dest, dest.length + 1);
				Memory.set(s1, '\0', 61); Memory.copy(s1, src, src.length);
				Memory.set(s2, '\0', 61); Memory.copy(s2, src, src.length);
				size_t len1 = 0;
				size_t len2 = 0;

				len1 = ft_strlcat(d1, s1, n);
				len2 = strlcat(d2, s2, n);
				bool b = true;
				if (len1 != len2) {
					stderr.printf("return > you: %zu, me: %zu", len1, len2);
					b = false;
				}
				if (Memory.cmp(d1, d2, 61) != 0) {
					stderr.printf("dest >  you: \"%s\" Me: \"%s\"", (string)d1, (string)d2);
					b = false;
				}
				return b;
			}).msg_err(@"strlcat(\"$dest\", \"$src\", $n)");
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
		}, "strlcat(NULL, \"\", 0)").msg_crash_warn());

		/* 20 */ result.append(SupraTest.test(null, () => {
			ft_strlcat(null, null, 0);
			return false;
		}, "strlcat(NULL, NULL, 0) No Crash").msg_need_segfault());

		/* 21 */ result.append(SupraTest.test(null, () => {
			ft_strlcat(null, null, 1);
			return false;
		}, "strlcat(NULL, NULL, 1) No Crash").msg_need_segfault());

		/* 22 */ result.append(SupraTest.test(null, () => {
			string str = "hello";
			ft_strlcat(str, null, 0);
			return false;
		}, "strlcat(\"hello\", NULL, 0) No Crash").msg_need_segfault());


		/* 23 */ result.append(SupraTest.test(null, () => {
			string str = "hello";
			ft_strlcat(str, null, 1);
			return false;
		}, "strlcat(\"hello\", NULL, 1) No Crash").msg_need_segfault());

		/* 24 */ result.append(SupraTest.test(null, () => {
			return (ft_strlcat(null, "source", 1) == 6);
		}, """strlcat(NULL, "source", 1) No Crash""").msg_need_segfault());

		/* 25 */ result.append(SupraTest.test(null, () => {
			size_t r = ft_strlcat(null, "source", 0);
			if (r != 6)
				stderr.printf("You: %zu Me: 6", r);
			return (r == 6);
		}, "strlcat(NULL, \"source\", 0)").msg_crash_warn());


		/* 26 */ result.append(SupraTest.test(null, () => {
			string s = "abcdef";
			size_t r = ft_strlcat(s, "source", 0);
			if (r != 6)
				stderr.printf("You: %zu Me: 6", r);
			return (r == 6);
		}).msg_err("strlcat(\"abcdef\", \"source\", 0)"));

		return (owned)result.str;
	}
	catch (Error e) {
		return @"$(result.str) \033[31m$(e.message)\033[0m";
	}
}
