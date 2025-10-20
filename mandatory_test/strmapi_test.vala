string run_strmapi() {
	var result = new StringBuilder.sized(250);
	result.append("STRMAPI:  ");
	try {
		var ft_strmapi = (d_strmapi)loader.symbol("ft_strmapi");

		string check(string s1, d_param_strmapi func, string cmp) {
			return SupraTest.test(null, () => {
				var s = ft_strmapi(s1, func);
				if (s == cmp)
					return true;
				stderr.printf("You:'%s' Me:'%s'", (string)s, cmp);
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
		/* 5 */ result.append(SupraTest.test(null, ()=>{
			SupraLeak.send_null();
			char *s = ft_strmapi("abc", ()=>{return 'e';});
			return (s == null);
		}, "no protect ").msg_err());

		return (owned)result.str;
	}
	catch (Error e) {
		return @"$(result.str) \033[31m$(e.message)\033[0m";
	}
}
