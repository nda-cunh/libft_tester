string run_isalnum() {
	string result = "ISALNUM:  ";
	try {
		var ft_isalnum= (d_isalnum)loader.symbol("ft_isalnum");
		var t = SupraTest.test(null, () => {
			for (int i = 0; i < 255; ++i)
			{
				if (clang_s(ft_isalnum(i)) != clang_s(clang_isalnum(i))) {
					stderr.printf("input: [%d] You: %d, Me: %d ", i, ft_isalnum(i), clang_isalnum(i));
					return false;
				}
			}
			return true;
		});
		return result + t.msg();
	}
	catch (Error e) {
		return @"$result \033[31m$(e.message)\033[0m";
	}
}
