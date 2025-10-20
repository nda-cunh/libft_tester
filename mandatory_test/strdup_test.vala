string run_strdup() {
	var result = new StringBuilder("STRDUP:   ");
	try {
		var ft_strdup = (d_strdup)loader.symbol("ft_strdup");

		string check(char *cmp) {
			var t = SupraTest.test(null, () => {
				char* s = ft_strdup(cmp);

				if (s == null)
					return false;
				return ((string)s == (string)cmp);
			}, "strdup('$cmp')");
			if (t.alloc != 1)
				return t.msg_ko(@"No alloc ??? $(t.alloc) alloc");
			if (t.bytes != ((string)cmp).length + 1)
				return t.msg_ko(@"Bad alloc size $(t.bytes)");
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
		/* 5 */ result.append(SupraTest.test(null, ()=>{
			SupraLeak.send_null();
			char *s = ft_strdup("bababababhc");
			if (s != null)
				delete s;
			return (s == null);
		}).msg_err("no protect "));

		return (owned)result.str;
	}
	catch (Error e) {
		return @"$(result.str) \033[31m$(e.message)\033[0m";
	}
}
