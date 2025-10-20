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
