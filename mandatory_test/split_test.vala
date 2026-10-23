string run_split() {
	var result = new StringBuilder.sized(250);
	result.append("SPLIT:    ");
	try {
		var ft_split = (d_split)loader.symbol("ft_split");

		var shield = new SupraTest.Shield();
		shield.check(() => {
			char **sp = ft_split(null, ' ');
			if (sp != null)
				strfreev((string[])sp);
			return true;
		}, "split(NULL, ' ')");
		result.append(shield.msg());

		string check(string str, char c, string? []cmp) {

			void free_print(char **sp, string []cmp, bool printing) {
				if (printing) {
					stderr.printf("Me: [");
					int j = 0;
					for (j = 0; j < cmp.length; j++) {
						if (j != 0)
							stderr.printf(", ");
						stderr.printf("\"%s\"", cmp[j]);
					}
					stderr.printf("] ");
					stderr.printf("You: [");
					if (sp == null) {
						stderr.printf("(null)");
					}
					else {
						for (j = 0; sp[j] != null; j++) {
							stderr.printf("\"%s\", ", (string)sp[j]);
						}
						stderr.printf("\"(null)\"");
					}

					stderr.printf("]");
					stderr.printf("\n");
				}
				if (sp != null) {
					strfreev((string[])sp);
				}
			}
			var t = SupraTest.test(null, () => {
				var sp = ft_split(str, c);
				if (sp == null) {
					free_print(sp, cmp, true);
					return false;
				}
				int len = 0;
				while (len < cmp.length && cmp[len] != null)
					len++;
				for (int j = 0; j < len; j++) {
					if (sp[j] == null || (string)sp[j] != cmp[j]) {
						free_print(sp, cmp, true);
						return false;
					}
				}
				if (sp[len] != null) {
					free_print(sp, cmp, true);
					return false;
				}

				free_print(sp, cmp, false);
				return true;
			});
			string msg;
			if (c == '\0')
				msg = t.msg_err(@"split(\"$str\", '\\0')-> ");
			else
				msg = t.msg_err(@"split(\"$str\", '$c')-> ");
			if (t.status == SIGSEGV)
				msg += "\033[91mme: [" + string.joinv(" ", cmp) + "]\n";
			return msg;
		}

		/* 1 */ result.append(check("a,a,a,a", ',', {"a", "a", "a", "a"}));
		/* 2 */ result.append(check("", ',', {null}));
		/* 3 */ result.append(check("a", ',', {"a"}));
		/* 4 */ result.append(check(",a", ',', {"a"}));
		/* 5 */ result.append(check("a,", ',', {"a"}));
		/* 6 */ result.append(check(",a,", ',', {"a"}));
		/* 7 */ result.append(check("salut", ',', {"salut"}));
		/* 8 */ result.append(check(",salut", ',', {"salut"}));
		/* 9 */ result.append(check("salut,", ',', {"salut"}));
		/* 10 */ result.append(check(",salut,", ',', {"salut"}));
		/* 11 */ result.append(check("--1-2--3---4----5-----42", '-', {"1", "2", "3", "4", "5", "42"}));
		/* 12 */ result.append(check(",", ',', {null}));
		/* 13 */ result.append(check(",,", ',', {null}));
		/* 14 */ result.append(check(",,,", ',', {null}));
		/* 15 */ result.append(check(",,,", '\0', {",,,"}));
		/* 16 */ result.append(check(" ", ',', {" "}));
		/* 17 */ result.append(check("          ", ' ', {null}));
		/* 18 */ result.append(check("", '\0', {null}));

		/* 19 */ result.append(check("lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed non risus. Suspendisse", ' ',
		{"lorem","ipsum","dolor","sit","amet,","consectetur","adipiscing","elit.","Sed","non","risus.","Suspendisse"}));
		/* 20 */ result.append(check("   lorem   ipsum dolor     sit amet, consectetur   adipiscing elit. Sed non risus. Suspendisse  ", ' ',
{"lorem","ipsum","dolor","sit","amet,","consectetur","adipiscing","elit.","Sed","non","risus.","Suspendisse"}));
		/* 21 */ result.append(check("lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed non risus. Suspendisse lectus tortor, dignissim sit amet, adipiscing nec, ultricies sed, dolor. Cras elementum ultricies diam. Maecenas ligula massa, varius a, semper congue, euismod non, mi.", 'i',
{"lorem ","psum dolor s","t amet, consectetur ad","p","sc","ng el","t. Sed non r","sus. Suspend","sse lectus tortor, d","gn","ss","m s","t amet, ad","p","sc","ng nec, ultr","c","es sed, dolor. Cras elementum ultr","c","es d","am. Maecenas l","gula massa, var","us a, semper congue, eu","smod non, m","."}));
		/* 22 */ result.append(check("lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed non risus. Suspendisse lectus tortor, dignissim sit amet, adipiscing nec, ultricies sed, dolor. Cras elementum ultricies diam. Maecenas ligula massa, varius a, semper congue, euismod non, mi.", 'z',
{"lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed non risus. Suspendisse lectus tortor, dignissim sit amet, adipiscing nec, ultricies sed, dolor. Cras elementum ultricies diam. Maecenas ligula massa, varius a, semper congue, euismod non, mi."}));
		/* 23 */ result.append(check("", 'z', {null}));

		/* 24 */ result.append(SupraTest.test_min_alloc(3 * sizeof(char*) + 3 + 3, ()=>{
			char **s = ft_split("ab cd", ' ');
			if (s == null)
				return false;
			strfreev((string[])s);
			return true;
		}, "split(\"ab cd\", ' ')").msg_err());
		/* 25 */ result.append(SupraTest.test_each_malloc((n)=>{
			SupraLeak.fail_at(n);
			char **s = ft_split("  bab abab   abhc ", ' ');
			SupraLeak.fail_at(0);
			if (SupraLeak.has_failed && s != null)
				stderr.printf("ft_split(\"  bab abab   abhc \", ' ') must return NULL when its malloc n°%d fails, but returned a result", n);
			else if (!SupraLeak.has_failed && s == null)
				stderr.printf("ft_split(\"  bab abab   abhc \", ' ') returned NULL but no malloc failed (expected [\"bab\", \"abab\", \"abhc\", NULL]): your function returns NULL outside of a malloc failure");
			if (s != null)
				strfreev((string[])s);
			return (SupraLeak.has_failed == (s == null));
		}, "no protect ").msg_err());

		return (owned)result.str;
	}
	catch (Error e) {
		return @"$(result.str) \033[31m$(e.message)\033[0m";
	}
}
