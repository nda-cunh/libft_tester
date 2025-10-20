string run_isascii() {
	string result = "ISASCII:  ";
	try {
		var ft_isascii= (d_isascii)loader.symbol("ft_isascii");
		var t = SupraTest.test(null, () => {
				for (int i = 0; i < 255; ++i)
				{
					if (clang_s(ft_isascii(i)) != clang_s(clang_isascii(i))) {
						stderr.printf("%d", i);
						return false;
					}
				}
				return true;
			});
		return result + t.msg_err("Bad Input:");
	}
	catch (Error e) {
		return @"$result \033[31m$(e.message)\033[0m";
	}
}
