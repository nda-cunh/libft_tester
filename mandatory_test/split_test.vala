string run_split() {
	var result = new StringBuilder.sized(250);
	result.append("SPLIT:    ");
	try {
		var ft_split = (d_split)loader.symbol("ft_split");

		string check(string str, char c, string? []cmp) {

			void free_print(char **sp, string []cmp, bool printing) {
				if (printing) {
					stderr.printf("Me: [ ");
					foreach (unowned var i in cmp) {
						stderr.printf("\"%s\" ", i);
					}
					stderr.printf("] ");
					stderr.printf("You: [ ");
					int j = 0;
					foreach (unowned var i in cmp) {
						if (sp[j] == null) {
							stderr.printf("\"(null)\"");
							break;
						}
						stderr.printf("\"%s\" ", (string)sp[j]);
						j++;
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
				// test if cmp is null
				if (cmp == null) {
					if (sp != null)
						free_print(sp, cmp, false);
					else
						return true;
				}
				int j = 0;
				foreach (unowned var i in cmp) {
					if ((string)sp[j] != i){
						free_print(sp, cmp, true);
						return false;
					}
					j++;
				}

				free_print(sp, cmp, false);
				return true;
			});
			var msg = t.msg_err(@"split(\"$str\", '$c')");
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
		/* 16 */ result.append(check("          ", ' ', {null}));

		/* 16 */ result.append(check("lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed non risus. Suspendisse", ' ',
		{"lorem","ipsum","dolor","sit","amet,","consectetur","adipiscing","elit.","Sed","non","risus.","Suspendisse"}));
		/* 16 */ result.append(check("   lorem   ipsum dolor     sit amet, consectetur   adipiscing elit. Sed non risus. Suspendisse  ", ' ',
{"lorem","ipsum","dolor","sit","amet,","consectetur","adipiscing","elit.","Sed","non","risus.","Suspendisse"}));
		/* 16 */ result.append(check("lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed non risus. Suspendisse lectus tortor, dignissim sit amet, adipiscing nec, ultricies sed, dolor. Cras elementum ultricies diam. Maecenas ligula massa, varius a, semper congue, euismod non, mi.", 'i',
{"lorem ","psum dolor s","t amet, consectetur ad","p","sc","ng el","t. Sed non r","sus. Suspend","sse lectus tortor, d","gn","ss","m s","t amet, ad","p","sc","ng nec, ultr","c","es sed, dolor. Cras elementum ultr","c","es d","am. Maecenas l","gula massa, var","us a, semper congue, eu","smod non, m","."}));
		/* 16 */ result.append(check("lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed non risus. Suspendisse lectus tortor, dignissim sit amet, adipiscing nec, ultricies sed, dolor. Cras elementum ultricies diam. Maecenas ligula massa, varius a, semper congue, euismod non, mi.", 'z',
{"lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed non risus. Suspendisse lectus tortor, dignissim sit amet, adipiscing nec, ultricies sed, dolor. Cras elementum ultricies diam. Maecenas ligula massa, varius a, semper congue, euismod non, mi."}));
		/* 16 */ result.append(check("", 'z', {null}));

		/* 17 */ result.append(SupraTest.test(null, ()=>{
			SupraLeak.send_null();
			char **s = ft_split("bababababhc", 'a');
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
