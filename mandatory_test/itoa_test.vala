string run_itoa() {
	var result = new StringBuilder.sized(250);
	result.append("ITOA:     ");
	try {
		var ft_itoa = (d_itoa)loader.symbol("ft_itoa");
		string check(int n, string? msg = null) {
			return SupraTest.test(null, () => {
				return (ft_itoa(n) == @"$n");
			}, msg ?? @"$n").msg();
		}
		/* 1 */ result.append(check(2147483647, "INT MAX "));
		/* 2 */ result.append(check(-2147483648, "INT MIN "));
		/* 3 */ result.append(check(0));
		/* 4 */ result.append(check(1));
		/* 5 */ result.append(check(2));
		/* 6 */ result.append(check(9));
		/* 7 */ result.append(check(10));
		/* 8 */ result.append(check(11));
		/* 9 */ result.append(check(42));
		/* 10 */ result.append(check(-1));
		/* 11 */ result.append(check(-2));
		/* 12 */ result.append(check(-9));
		/* 13 */ result.append(check(-10));
		/* 14 */ result.append(check(-11));
		/* 15 */ result.append(check(-42));
		/* 17 */ result.append(check(6942069));
		/* 17 */ result.append(check(14698465));
		/* 18 */ result.append(check(-16465));
		/* 19 */ result.append(check(546465));
		/* 20 */ result.append(check(-164465));
		/* 21 */ result.append(check(684));
		/* 22 */ result.append(check(-68465));
		/* 23 */ result.append(check(6851465));
		/* 24 */
		result.append(SupraTest.test(null, ()=>{
			SupraLeak.send_null();
			char *s = ft_itoa(42);
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
