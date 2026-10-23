string run_strdup() {
	var result = new StringBuilder("STRDUP:   ");
	try {
		var ft_strdup = (d_strdup)loader.symbol("ft_strdup");

		string check(char *cmp) {
			var t = SupraTest.test(null, () => {
				char* s = ft_strdup(cmp);

				if (s == null)
					return false;
				bool is_same = ((string)s == (string)cmp);
				if (!is_same)
					stderr.printf("You:\"%s\" Me:\"%s\"", (string)s, (string)cmp);
				free(s);
				return is_same;
			}, @"strdup(\"$((string)cmp)\")");
			if (t.status != OK)
				return t.msg_err();
			if (t.alloc != 1)
				return t.msg_ko(@"strdup(\"$((string)cmp)\") $(t.alloc) malloc instead of 1");
			if (t.bytes < ((string)cmp).length + 1)
				return t.msg_ko(@"strdup(\"$((string)cmp)\") alloc $(t.bytes) bytes instead of at least $(((string)cmp).length + 1)");
			return t.msg_ok();
		}

		/* 1 */ result.append(check("abc"));
		/* 2 */ result.append(check("Abc"));
		/* 3 */ result.append(check("abc\0yop"));
		/* 4 */ result.append(check("abc 12345\0yop"));
		/* 5 */ result.append(check("abc 12345\0yop"));
		/* 6 */ result.append(check("lorem ipsum dolor sit amet"));
		/* 7 */ result.append(check("lorem ipsum dolor sit amet lorem ipsum dolor sit amet"));
		/* 8 */ result.append(check(""));

		// Test if strdup segfault
		/* 9 */ result.append(SupraTest.test(null, () => {
			ft_strdup(null);
			return false;
		}, "strdup(NULL) NOCRASH").msg_need_segfault());

		// Test if strdup protect (malloc)
		/* 10 */ result.append(SupraTest.test_each_malloc((n)=>{
			SupraLeak.fail_at(n);
			char *s = ft_strdup("bababababhc");
			SupraLeak.fail_at(0);
			if (SupraLeak.has_failed && s != null)
				stderr.printf("ft_strdup(\"bababababhc\") must return NULL when its malloc n°%d fails, but returned a result", n);
			else if (!SupraLeak.has_failed && s == null)
				stderr.printf("ft_strdup(\"bababababhc\") returned NULL but no malloc failed (expected \"bababababhc\"): your function returns NULL outside of a malloc failure");
			if (s != null)
				delete s;
			return (SupraLeak.has_failed == (s == null));
		}, "no protect ").msg_err());

		return (owned)result.str;
	}
	catch (Error e) {
		return @"$(result.str) \033[31m$(e.message)\033[0m";
	}
}
