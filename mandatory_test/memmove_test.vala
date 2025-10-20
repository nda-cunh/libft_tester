string run_memmove() {
	string result = "MEMMOVE:  ";
	try {
		var ft_memmove = (d_memmove)loader.symbol("ft_memmove");
		result += SupraTest.test(null, () => {
			string mstr = "Hello, World!";
			char *str = (char*)mstr;
			size_t n = mstr.length + 1;
			ft_memmove(str + 7, str, n);
			return (str == "Hello, Hello, World!");
		}, "test same_memory").msg();


		result += SupraTest.test(null, () => {
			string mstr = "Hello, World!";
			char *str = (char*)mstr;
			size_t n = mstr.length + 1;
			ft_memmove(str + 2, str, n);
			return (str == "HeHello, World!");
		}, "test overlap").msg();

		result += SupraTest.test(null, () => {
			string msrc = "Source";
			char *src = msrc;
			char dest[20];
			size_t n = msrc.length + 1;
			ft_memmove(dest, src, n);
			return ((char*)dest == "Source");
			}, "test different_memory").msg();

		return result;
	}
	catch (Error e) {
		return @"$result \033[31m$(e.message)\033[0m";
	}
}
