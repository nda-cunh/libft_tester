string run_strrchr() {
	string result = "STRRCHR:  ";
	try {
		var ft_strrchr = (d_strrchr)loader.symbol("ft_strrchr");

		string check (char* s, int c, string? msg = null) {
			string cp;
			if (c == '\0')
				cp = "'\\0'";
			else
				cp = ((char)c).to_string();
			var p = SupraTest.test(null, () => {
				var a = strrchr(s, c);
				var b = ft_strrchr(s, c);
				if (a != b) {
					stderr.printf("libc: %s you: %s ", ((string)a) ?? "null", ((string)b) ?? "(null)");
					return false;
				}
				return true;
			}, msg.printf(cp)).msg_err();
			return (owned)p;
		}

		result += check("suprapatata\0vttiX",	's', """strrchr("suprapatata\0vttiX", '%s')""");
		result += check("suprapatata\0vttiX",	'a', """strrchr("suprapatata\0vttiX", '%s')""");
		result += check("suprapatata\0vttiX",	'v', """strrchr("suprapatata\0vttiX", '%s')""");
		result += check("suprapatata\0vttiX",	'p', """strrchr("suprapatata\0vttiX", '%s')""");
		result += check("suprapatata\0vttiX",	'r', """strrchr("suprapatata\0vttiX", '%s')""");
		result += check("suprapatata\0vttiX",	't', """strrchr("suprapatata\0vttiX", '%s')""");
		result += check("suprapatata\0vttiX",	'X', """strrchr("suprapatata\0vttiX", '%s')""");
		result += check("suprapatata\0vttiX",	'b', """strrchr("suprapatata\0vttiX", '%s')""");
		result += check("suprapatata\0vttiX",	'i', """strrchr("suprapatata\0vttiX", '%s')""");
		result += check("suprapatata\0vttiX",	'E', """strrchr("suprapatata\0vttiX", '%s')""");
		result += check("suprapatata\0vttiX",	'\0', """strrchr("suprapatata\0vttiX", '%s')""");
		result += check("Hey Supra",			'\0', """strrchr("Hey Supra", '%s')""");
		result += check("\0",					'\0', """strrchr("\0", '%s')""");

		result += SupraTest.test(null, () => {
				const string s = "bonjour";
				int c = 'b';
				return (strrchr(s.offset(2), c) == ft_strrchr(s.offset(2), c));
		}, """buf = "bonjour" strrchr(buf + 2, 'b') """).msg();
		
		result += SupraTest.test(null, () => {
				const string s = "1024";
				int c = 't' + 256;
				return (strrchr(s, c) == ft_strrchr(s.offset(2), c));
		}, """buf = "1024" strrchr(buf, ('t' + 256) (unsigned char) """).msg();

		result += SupraTest.test(null, () => {
				ft_strrchr(null, '\0');
				return false;
		}, """strrchr(NULL, '\0')""").msg_need_segfault();

		result += SupraTest.test(null, () => {
				ft_strrchr(null, 'c');
				return false;
		}, """strrchr(NULL, 'c')""").msg_need_segfault();
	}
	catch (Error e) {
		return @"$result \033[31m$(e.message)\033[0m";
	}
	return result;
}
