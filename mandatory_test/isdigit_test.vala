string run_isdigit() {
	string result = "ISDIGIT:  ";
	try {
		var ft_isdigit= (d_isdigit)loader.symbol("ft_isdigit");
		var t = SupraTest.test(null, () => {
				for (int i = 0; i < 255; ++i)
				{
					if (clang_s(ft_isdigit(i)) != clang_s(clang_isdigit(i))) {
						stderr.printf("input: [%d] You: %d, Me: %d ", i, ft_isdigit(i), clang_isdigit(i));
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
