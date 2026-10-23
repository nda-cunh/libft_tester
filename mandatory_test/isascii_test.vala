string run_isascii() {
	string result = "ISASCII:  ";
	try {
		var ft_isascii = (d_isascii)loader.symbol("ft_isascii");
		// the libc answer depends on the locale: use the "C" locale rule
		bool me(int i) {
			return (i >= 0 && i <= 127);
		}
		var t = SupraTest.test(null, () => {
			// EOF and every unsigned char
			for (int i = -1; i <= 255; ++i)
			{
				if ((ft_isascii(i) != 0) != me(i)) {
					stderr.printf("isascii(%d) You: %d Me: %s ", i, ft_isascii(i), me(i) ? "true" : "false");
					return false;
				}
			}
			// isascii is defined for every int
			int[] others = {-129, -128, 256, 300, 384, int.MIN, int.MAX};
			foreach (int i in others) {
				if ((ft_isascii(i) != 0) != me(i)) {
					stderr.printf("isascii(%d) You: %d Me: %s ", i, ft_isascii(i), me(i) ? "true" : "false");
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
