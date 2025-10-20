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
