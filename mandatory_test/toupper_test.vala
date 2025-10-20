string run_toupper() {
	string result = "TOUPPER:  ";
	try {
		var ft_toupper= (d_toupper)loader.symbol("ft_toupper");
		var t = SupraTest.test(null, () => {
			for (int i = 0; i < 255; ++i)
			{
				if (ft_toupper(i) != clang_toupper(i))
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
