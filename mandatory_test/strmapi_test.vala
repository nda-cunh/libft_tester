string run_strmapi() {
	var result = new StringBuilder.sized(250);
	result.append("STRMAPI:  ");
	try {
		var ft_strmapi = (d_strmapi)loader.symbol("ft_strmapi");

		var shield = new SupraTest.Shield();
		shield.check(() => {
			free(ft_strmapi(null, (n, c) => { return c; }));
			return true;
		}, "strmapi(NULL, f)");
		shield.check(() => {
			free(ft_strmapi("abc", null));
			return true;
		}, "strmapi(\"abc\", NULL)");
		result.append(shield.msg());

		string check(string s1, d_param_strmapi func, string cmp) {
			return SupraTest.test(null, () => {
				var s = ft_strmapi(s1, func);
				if (s == cmp)
					return true;
				stderr.printf("You:%s Me:\"%s\"", quote(s), cmp);
				return false;
			}).msg_err("");
		}

		/* 1 */ result.append(check("salut", (n, c)=>{
				return 'e';
			}, "eeeee"));
		/* 2 */ result.append(check("abcde", (n, c)=>{
				return c + 1;
			}, "bcdef"));
		/* 3 */ result.append(check("chocolat", (n, c)=>{
				if (n % 2 == 0)
					return c;
				return c - 32;
			}, "cHoCoLaT"));
		/* 4 */ result.append(check("chocolat", (n, c)=>{
				if (n == 3 || n == 5)
					return c - 32;
				return c;
			}, "choCoLat"));
		/* 5 */ result.append(SupraTest.test_min_alloc(5, ()=>{
			char *s = ft_strmapi("abcd", ()=>{return 'e';});
			if (s == null)
				return false;
			delete s;
			return true;
		}, "strmapi(\"abcd\", f)").msg_err());
		/* 6 */ result.append(SupraTest.test_each_malloc((n)=>{
			SupraLeak.fail_at(n);
			char *s = ft_strmapi("abc", ()=>{return 'e';});
			SupraLeak.fail_at(0);
			if (SupraLeak.has_failed && s != null)
				stderr.printf("ft_strmapi(\"abc\", f) must return NULL when its malloc n°%d fails, but returned a result", n);
			else if (!SupraLeak.has_failed && s == null)
				stderr.printf("ft_strmapi(\"abc\", f) returned NULL but no malloc failed (expected \"eee\"): your function returns NULL outside of a malloc failure");
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
