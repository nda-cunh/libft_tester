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
