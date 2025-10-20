string run_strchr() {
	string result = "STRCHR:   ";
	try {
		var ft_strchr = (d_strchr)loader.symbol("ft_strchr");

		string check (char* s, int c, string? msg = null) {
			string cp;
			if (c == '\0')
				cp = "'\\0'";
			else
				cp = ((char)c).to_string();
			var p = SupraTest.test(null, () => {
				var a = strchr(s, c);
				var b = ft_strchr(s, c);
				if (a != b) {
					stderr.printf("libc: %s you: %s ", ((string)a) ?? "null", ((string)b) ?? "(null)");
					return false;
				}
				return true;
			}, msg.printf(cp)).msg_err();
			return (owned)p;
		}

		result += check("suprapatata\0vttiX",	's', """strchr("suprapatata\0vttiX", '%s')""");
		result += check("suprapatata\0vttiX",	'a', """strchr("suprapatata\0vttiX", '%s')""");
		result += check("suprapatata\0vttiX",	'v', """strchr("suprapatata\0vttiX", '%s')""");
		result += check("suprapatata\0vttiX",	'p', """strchr("suprapatata\0vttiX", '%s')""");
		result += check("suprapatata\0vttiX",	'r', """strchr("suprapatata\0vttiX", '%s')""");
		result += check("suprapatata\0vttiX",	't', """strchr("suprapatata\0vttiX", '%s')""");
		result += check("suprapatata\0vttiX",	'X', """strchr("suprapatata\0vttiX", '%s')""");
		result += check("suprapatata\0vttiX",	'b', """strchr("suprapatata\0vttiX", '%s')""");
		result += check("suprapatata\0vttiX",	'i', """strchr("suprapatata\0vttiX", '%s')""");
		result += check("suprapatata\0vttiX",	'E', """strchr("suprapatata\0vttiX", '%s')""");
		result += check("suprapatata\0vttiX",	'\0', """strchr("suprapatata\0vttiX", '%s')""");
		result += check("Hey Supra",			'\0', """strchr("Hey Supra", '%s')""");
		result += check("\0",					'\0', """strchr("\0", '%s')""");

		result += SupraTest.test(null, () => {
				const string s = "\0";
				int c = '\0';
				return (strchr(s, c) == ft_strchr(s, c));
		}, """strchr("\0", '\0')""").msg();

		result += SupraTest.test(null, () => {
				const string s = "1024";
				int c = '\0';
				return (strchr(s, c) == ft_strchr(s, c));
		}, """strchr("1024", '\0')""").msg();
		
		result += SupraTest.test(null, () => {
				const string s = "1024";
				int c = 't' + 256;
				return (strchr(s, c) == ft_strchr(s, c));
		}, """strchr("1024", ('t' + 256))""").msg();

		result += SupraTest.test(null, () => {
				ft_strchr(null, '\0');
				return false;
		}, """strchr(NULL, '\0')""").msg_need_segfault();

		result += SupraTest.test(null, () => {
				ft_strchr(null, 'c');
				return false;
		}, """strchr(NULL, 'c')""").msg_need_segfault();
	}
	catch (Error e) {
		return @"$result \033[31m$(e.message)\033[0m";
	}
	return result;
}
