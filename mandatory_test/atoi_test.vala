string run_atoi() {
	var result = new StringBuilder.sized(200);
	result.append("ATOI:     ");
	try {
		var ft_atoi = (d_atoi)loader.symbol("ft_atoi");
		string check(string s_nb){
			return SupraTest.test(null, () => {
				var a = ft_atoi(s_nb);
				var b = atoi(s_nb);
				stderr.printf("You:%d Me:%d", a, b);
				return (a == b);
			}).msg_err(@"Atoi('$s_nb')");
		}
		/* 1 */ result.append(check("2147483647"));
		/* 2 */ result.append(check("-2147483648"));
		/* 3 */ result.append(check("0"));
		/* 4 */ result.append(check("1"));
		/* 5 */ result.append(check("2"));
		/* 6 */ result.append(check("9"));
		/* 7 */ result.append(check("10"));
		/* 8 */ result.append(check("11"));
		/* 9 */ result.append(check("42"));
		/* 10 */ result.append(check("-1"));
		/* 11 */ result.append(check("-2"));
		/* 12 */ result.append(check("-9"));
		/* 13 */ result.append(check("-10"));
		/* 14 */ result.append(check("-11"));
		/* 15 */ result.append(check("-42"));
		/* 16 */ result.append(check("165468465"));
		/* 17 */ result.append(check("   \t\r\f\v\t-2145"));
		/* 18 */ result.append(check("   \t\t--2145"));
		/* 19 */ result.append(check("   \t\t-a2145"));
		/* 20 */ result.append(check("   \t\t-8a2145"));
		/* 21 */ result.append(check("   \n 28fkldjgd42"));
		/* 22 */ result.append(check("   \n\f\r\n\t\v"));
		/* 23 */ result.append(check("+999"));
		/* 24 */ result.append(check(" 000002147483647"));
		/* 25 */ result.append(check(" 000-2147483648"));

		/* 26 */
		for (int N = 0; N < 5; ++N)
		{
			var i = Random.int_range(int.MIN, int.MAX);
			result.append(check(@"$i"));
		}
		return (owned)result.str;
	}
	catch (Error e) {
		return @"$(result.str) \033[31m$(e.message)\033[0m";
	}
}
