string run_strjoin() {
	var result = new StringBuilder.sized(250);
	result.append("STRJOIN:  ");
	try {
		var ft_strjoin = (d_strjoin)loader.symbol("ft_strjoin");

		var shield = new SupraTest.Shield();
		shield.check(() => {
			free(ft_strjoin(null, "a"));
			return true;
		}, "strjoin(NULL, \"a\")");
		shield.check(() => {
			free(ft_strjoin("a", null));
			return true;
		}, "strjoin(\"a\", NULL)");
		shield.check(() => {
			free(ft_strjoin(null, null));
			return true;
		}, "strjoin(NULL, NULL)");
		result.append(shield.msg());

		string check(string s1, string s2, string cmp) {
			return SupraTest.test(null, () => {
				var s = ft_strjoin(s1, s2);
				if (s == cmp)
					return true;
				stderr.printf("You:%s Me:\"%s\"", quote(s), cmp);
				return false;
			}).msg_err(@"strjoin(\"$s1\", \"$s2\") ");
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

		/* 10 */ result.append(SupraTest.test_min_alloc(6, ()=>{
			char *s = ft_strjoin("abc", "de");
			if (s == null)
				return false;
			delete s;
			return true;
		}, "strjoin(\"abc\", \"de\")").msg_err());
		/* 11 */ result.append(SupraTest.test_each_malloc((n)=>{
			SupraLeak.fail_at(n);
			char *s = ft_strjoin("ab", "ab");
			SupraLeak.fail_at(0);
			if (SupraLeak.has_failed && s != null)
				stderr.printf("ft_strjoin(\"ab\", \"ab\") must return NULL when its malloc n°%d fails, but returned a result", n);
			else if (!SupraLeak.has_failed && s == null)
				stderr.printf("ft_strjoin(\"ab\", \"ab\") returned NULL but no malloc failed (expected \"abab\"): your function returns NULL outside of a malloc failure");
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
