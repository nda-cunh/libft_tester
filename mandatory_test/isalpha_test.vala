string run_isalpha() {
	string result = "IS_ALPHA: ";
	try {
		var ft_isalpha= (d_isalpha)loader.symbol("ft_isalpha");
		var t = SupraTest.test(null, () => {
			for (int i = 0; i < 255; ++i)
			{
				if (clang_s(ft_isalpha(i)) != clang_s(clang_isalpha(i))) {
					stderr.printf("input: [%d] You: %d, Me: %d ", i, ft_isalpha(i), clang_isalpha(i));
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
