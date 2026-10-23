string run_isalpha() {
	string result = "IS_ALPHA: ";
	try {
		var ft_isalpha = (d_isalpha)loader.symbol("ft_isalpha");
		// the libc answer depends on the locale: use the "C" locale rule
		bool me(int i) {
			return (i >= 'A' && i <= 'Z') || (i >= 'a' && i <= 'z');
		}
		var t = SupraTest.test(null, () => {
			// EOF and every unsigned char
			for (int i = -1; i <= 255; ++i)
			{
				if ((ft_isalpha(i) != 0) != me(i)) {
					stderr.printf("isalpha(%d) You: %d Me: %s ", i, ft_isalpha(i), me(i) ? "true" : "false");
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
