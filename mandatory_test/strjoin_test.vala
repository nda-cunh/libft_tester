string run_strjoin() {
	var result = new StringBuilder.sized(250);
	result.append("STRJOIN:  ");
	try {
		var ft_strjoin = (d_strjoin)loader.symbol("ft_strjoin");

		string check(string s1, string s2, string cmp) {
			return SupraTest.test(null, () => {
				var s = ft_strjoin(s1, s2);
				if (s == cmp)
					return true;
				stderr.printf("You:'%s' Me:'%s'", (string)s ?? "(null)", cmp);
				return false;
			}).msg_err(@"test: ('$s1', $s2) ");
		}

		/* 1 */ result.append(check("hello ", "salut", "hello salut"));
		/* 2 */ result.append(check("a", "b", "ab"));
		/* 3 */ result.append(check("", "b", "b"));
		/* 4 */ result.append(check("a", "", "a"));
		/* 5 */ result.append(check("", "", ""));
		/* 6 */ result.append(check("lusersupra testu le dartien", "supra test", "lusersupra testu le dartiensupra test"));
		/* 7 */ result.append(check("", "suprluserbu le dartien test", "suprluserbu le dartien test"));
		/* 8 */ result.append(check("luserbu le dartien", "", "luserbu le dartien"));
		/* 9 */ result.append(check("a a a a a a a", "a a a a a a a  a a  a   a a  ", "a a a a a a aa a a a a a a  a a  a   a a  "));

		/* 10 */ result.append(SupraTest.test(null, ()=>{
			SupraLeak.send_null();
			char *s = ft_strjoin("ab", "ab");
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
