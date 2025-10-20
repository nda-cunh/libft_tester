string run_striteri() {
	var result = new StringBuilder.sized(250);
	result.append("STRITERI: ");
	try {
		var ft_striteri = (d_striteri)loader.symbol("ft_striteri");

		string check(string s1, d_param_striteri func, string cmp) {
			return SupraTest.test(null, () => {
				ft_striteri(s1, func);
				if (s1 == cmp)
					return true;
				stderr.printf("You:'%s' Me:'%s'", s1, cmp);
				return false;
			}).msg_err("");
		}

		/* 1 */ result.append(check("salut", (n, s)=>{
				s[0] = 'e';
			}, "eeeee"));
		/* 2 */ result.append(check("abcde", (n, s)=>{
				s[0] = s[0] + 1;
			}, "bcdef"));
		/* 3 */ result.append(check("chocolat", (n, s)=>{
				if (n % 2 != 0)
					s[0] = s[0] - 32;
			}, "cHoCoLaT"));
		/* 4 */ result.append(check("chocolat", (n, s)=>{
				if (n == 3 || n == 5)
					s[0] = s[0] - 32;
			}, "choCoLat"));
		/* 5 */ result.append(check("chocolat", (n, s)=>{
				if (n == 0){
					s[1] = 'V';
					s[3] = 'V';
				}
				if (n == 5){
					s[-1] = 'h';
				}
			}, "cVoVhlat"));
		return (owned)result.str;
	}
	catch (Error e) {
		return @"$(result.str) \033[31m$(e.message)\033[0m";
	}
}
