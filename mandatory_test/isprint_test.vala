string run_isprint() {
	string result = "ISPRINT:  ";
	try {
		var ft_isprint= (d_isprint)loader.symbol("ft_isprint");
		var t = SupraTest.test(null, () => {
				for (int i = 0; i < 255; ++i)
				{
					if (clang_s(ft_isprint(i)) != clang_s(clang_isprint(i))) {
						stderr.printf("%d", i);
						return false;
					}
				}
				return true;
			});
		return result + t.msg_err("Input: ");
	}
	catch (Error e) {
		return @"$result \033[31m$(e.message)\033[0m";
	}
}
