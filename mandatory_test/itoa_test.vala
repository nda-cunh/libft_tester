string run_itoa() {
	var result = new StringBuilder.sized(250);
	result.append("ITOA:     ");
	try {
		var ft_itoa = (d_itoa)loader.symbol("ft_itoa");
		string check(int n, string? msg = null) {
			return SupraTest.test(null, () => {
				string s = ft_itoa(n);
				stderr.printf("You:'%s' Me:'%d'", s, n);
				return (s == @"$n");
			}).msg_err();
		}
		/* 1 */ result.append(check(2147483647));
		/* 2 */ result.append(check(-2147483648));
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
		result.append(SupraTest.test_each_malloc((n)=>{
			SupraLeak.fail_at(n);
			char *s = ft_itoa(-42);
			SupraLeak.fail_at(0);
			if (SupraLeak.has_failed && s != null)
				stderr.printf("ft_itoa(-42) must return NULL when its malloc n°%d fails, but returned a result", n);
			else if (!SupraLeak.has_failed && s == null)
				stderr.printf("ft_itoa(-42) returned NULL but no malloc failed (expected \"-42\"): your function returns NULL outside of a malloc failure");
			if (s != null)
				delete s;
			return (SupraLeak.has_failed == (s == null));
		}, "no protect malloc ").msg_err());
		return (owned)result.str;
	}
	catch (Error e) {
		return @"$(result.str) \033[31m$(e.message)\033[0m";
	}
}
