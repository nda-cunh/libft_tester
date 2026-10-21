string run_substr() {
	var result = new StringBuilder.sized(250);
	result.append("SUBSTR:   ");
	try {
		var ft_substr = (d_substr)loader.symbol("ft_substr");

		string check(string str, uint start, size_t len, string sp) {

			var t = SupraTest.test(null, () => {
				char *sp1 = ft_substr(str, start, len);
				if (sp1 != null) {
					if ((string)sp1 == sp) {
						free(sp1);
						return true;
					}
				}
				stderr.printf("[You:'%s' != Me:'%s'] ", sp1 == null ? "(null)" : ((string)sp1).compress(), sp);
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

		// the allocated size must be the size of the result, not len + 1
		string check_size(string str, uint start, size_t len, size_t expected) {
			var t = SupraTest.test(null, () => {
				char *s = ft_substr(str, start, len);
				free(s);
				return (s != null);
			}, @"substr('$str', $start, $len)");
			if (t.status != OK)
				return t.msg_err();
			if (t.bytes != expected)
				return t.msg_ko(@"substr('$str', $start, $len) alloc $(t.bytes) bytes instead of $expected ");
			return t.msg_ok();
		}
		/* 16 */ result.append(check_size("hello", 1, int.MAX, 5));
		/* 17 */ result.append(check_size("hello", 0, 100, 6));
		/* 18 */ result.append(check_size("hello", 3, 5, 3));
		/* 19 */ result.append(check_size("hello", 2, 3, 4));
		/* 20 */ result.append(check_size("hello", 0, size_t.MAX, 6));
		/* 21 */ result.append(check_size("hello", 10, 5, 1));

		/* 22 */ result.append(SupraTest.test(null, ()=>{
			SupraLeak.send_null();
			char *s = ft_substr("abc", 1, 3);
			if (s != null)
				delete s;
			return (s == null);
		}, "no protect ").msg_err());
		/* 23 */ result.append(SupraTest.test(null, ()=>{
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
