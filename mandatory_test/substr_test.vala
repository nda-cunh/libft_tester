string run_substr() {
	var result = new StringBuilder.sized(250);
	result.append("SUBSTR:   ");
	try {
		var ft_substr = (d_substr)loader.symbol("ft_substr");

		var shield = new SupraTest.Shield();
		shield.check(() => {
			free(ft_substr(null, 0, 5));
			return true;
		}, "substr(NULL, 0, 5)");
		result.append(shield.msg());

		string check(string str, uint start, size_t len, string sp) {

			var t = SupraTest.test(null, () => {
				char *sp1 = ft_substr(str, start, len);
				if (sp1 != null) {
					if ((string)sp1 == sp) {
						free(sp1);
						return true;
					}
				}
				stderr.printf("[You:%s != Me:\"%s\"] ", quote(sp1 == null ? null : ((string)sp1).compress()), sp);
				free(sp1);
				return false;
			});


			return t.msg(@"substr(\"$str\", $start, $len) $(t.stderr)");
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
		/* 16 */ result.append(check("hello", 5, 3, ""));
		/* 17 */ result.append(check("hello", 4, size_t.MAX, "o"));

		// the result needs at least its length + 1 bytes (len + 1 overflows with a huge len)
		string check_size(string str, uint start, size_t len, size_t expected) {
			return SupraTest.test_min_alloc(expected, () => {
				char *s = ft_substr(str, start, len);
				free(s);
				return (s != null);
			}, @"substr(\"$str\", $start, $len)").msg_err();
		}
		/* 18 */ result.append(check_size("hello", 1, int.MAX, 5));
		/* 19 */ result.append(check_size("hello", 0, 100, 6));
		/* 20 */ result.append(check_size("hello", 3, 5, 3));
		/* 21 */ result.append(check_size("hello", 2, 3, 4));
		/* 22 */ result.append(check_size("hello", 0, size_t.MAX, 6));
		/* 23 */ result.append(check_size("hello", 10, 5, 1));
		/* 24 */ result.append(check_size("hello", 5, 3, 1));
		/* 25 */ result.append(check_size("hello", 0, 0, 1));
		/* 26 */ result.append(check_size("hello", 4, 1, 2));

		/* 27 */ result.append(SupraTest.test_each_malloc((n)=>{
			SupraLeak.fail_at(n);
			char *s = ft_substr("abc", 1, 3);
			SupraLeak.fail_at(0);
			if (SupraLeak.has_failed && s != null)
				stderr.printf("ft_substr(\"abc\", 1, 3) must return NULL when its malloc n°%d fails, but returned a result", n);
			else if (!SupraLeak.has_failed && s == null)
				stderr.printf("ft_substr(\"abc\", 1, 3) returned NULL but no malloc failed (expected \"bc\"): your function returns NULL outside of a malloc failure");
			if (s != null)
				delete s;
			return (SupraLeak.has_failed == (s == null));
		}, "no protect ").msg_err());
		/* 28 */ result.append(SupraTest.test_each_malloc((n)=>{
			SupraLeak.fail_at(n);
			char *s = ft_substr("abc", 5, 3);
			SupraLeak.fail_at(0);
			if (SupraLeak.has_failed && s != null)
				stderr.printf("ft_substr(\"abc\", 5, 3) must return NULL when its malloc n°%d fails, but returned a result", n);
			else if (!SupraLeak.has_failed && s == null)
				stderr.printf("ft_substr(\"abc\", 5, 3) returned NULL but no malloc failed (expected \"\"): your function returns NULL outside of a malloc failure");
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
