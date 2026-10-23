string run_toupper() {
	string result = "TOUPPER:  ";
	try {
		var ft_toupper = (d_toupper)loader.symbol("ft_toupper");
		// the libc answer depends on the locale: use the "C" locale rule
		int me(int i) {
			return (i >= 'a' && i <= 'z') ? i - 32 : i;
		}
		var t = SupraTest.test(null, () => {
			// EOF and every unsigned char
			for (int i = -1; i <= 255; ++i)
			{
				if (ft_toupper(i) != me(i)) {
					stderr.printf("toupper(%d) You: %d Me: %d ", i, ft_toupper(i), me(i));
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
