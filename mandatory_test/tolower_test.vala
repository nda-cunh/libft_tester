string run_tolower() {
	string result = "TOLOWER:  ";
	try {
		var ft_tolower= (d_tolower)loader.symbol("ft_tolower");
		var t = SupraTest.test(null, () => {
				for (int i = 0; i < 255; ++i)
				{
					if (ft_tolower(i) != clang_tolower(i))
						return false;
				}
				return true;
			});
		return result + t.msg();
	}
	catch (Error e) {
		return @"$result \033[31m$(e.message)\033[0m";
	}
}
