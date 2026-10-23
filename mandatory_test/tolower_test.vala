string run_tolower() {
	string result = "TOLOWER:  ";
	try {
		var ft_tolower = (d_tolower)loader.symbol("ft_tolower");
		// the libc answer depends on the locale: use the "C" locale rule
		int me(int i) {
			return (i >= 'A' && i <= 'Z') ? i + 32 : i;
		}
		var t = SupraTest.test(null, () => {
			// EOF and every unsigned char
			for (int i = -1; i <= 255; ++i)
			{
				if (ft_tolower(i) != me(i)) {
					stderr.printf("tolower(%d) You: %d Me: %d ", i, ft_tolower(i), me(i));
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
