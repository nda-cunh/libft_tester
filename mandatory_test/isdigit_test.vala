string run_isdigit() {
	string result = "ISDIGIT:  ";
	try {
		var ft_isdigit = (d_isdigit)loader.symbol("ft_isdigit");
		// the libc answer depends on the locale: use the "C" locale rule
		bool me(int i) {
			return (i >= '0' && i <= '9');
		}
		var t = SupraTest.test(null, () => {
			// EOF and every unsigned char
			for (int i = -1; i <= 255; ++i)
			{
				if ((ft_isdigit(i) != 0) != me(i)) {
					stderr.printf("isdigit(%d) You: %d Me: %s ", i, ft_isdigit(i), me(i) ? "true" : "false");
					return false;
				}
			}
			return true;
		});
		return result + t.msg_err();
	}
	catch (Error e) {
		return @"$result \033[31m$(e.message)\033[0m";
	}
}
