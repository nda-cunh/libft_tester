string run_isprint() {
	string result = "ISPRINT:  ";
	try {
		var ft_isprint = (d_isprint)loader.symbol("ft_isprint");
		// the libc answer depends on the locale: use the "C" locale rule
		bool me(int i) {
			return (i >= 32 && i <= 126);
		}
		var t = SupraTest.test(null, () => {
			// EOF and every unsigned char
			for (int i = -1; i <= 255; ++i)
			{
				if ((ft_isprint(i) != 0) != me(i)) {
					stderr.printf("isprint(%d) You: %d Me: %s ", i, ft_isprint(i), me(i) ? "true" : "false");
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
