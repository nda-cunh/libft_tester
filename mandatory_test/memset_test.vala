string run_memset() {
	string result = "MEMSET:   ";
	try {
		var ft_memset = (d_memset)loader.symbol("ft_memset");
		result += SupraTest.test(null, () => {
			uint8 buf[20];
			ft_memset(buf, 'E', 6);
			buf[6] = '\0';
			return((string)buf == "EEEEEE");
		}, "memset(mem, E, 6)").msg();

		result += SupraTest.test(null, () => {
			uint8 buf[20];
			ft_memset(buf, 'E', 6);
			buf[6] = '\0';
			return(buf[7] != 'E');
		}, "trop loin... ft_memset(buf, 'E', 6)").msg();

		result += SupraTest.test(null, () => {
			uint8 buf[20];
			buf[5] = '\0';
			ft_memset(buf, 'E', 6);
			buf[6] = '\0';
			return(buf[5] == 'E');
		}, "pas assez loin... ft_memset(buf, 'E', 6").msg();

		result += SupraTest.test(null, () => {
			uint8 buf[5];
			buf[0] = 'J';
			ft_memset(buf, 'E', 0);
			return(buf[0] == 'J');
		}, "ft_memset(buf, 'E', 0)").msg();

		result += SupraTest.test(null, () => {
			ft_memset(null, 0, 0);
			return true;
		}, """ft_memset(NULL, 0, 0)""").msg();

		result += SupraTest.test(null, () => {
			ft_memset(null, 0, 1);
			return true;
		}, "No segfault with memset(null, 0, 1)").msg_need_segfault();


		return result;
	}
	catch (Error e) {
		return @"$result \033[31m$(e.message)\033[0m";
	}
}
