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
			Memory.set(buf, '\0', buf.length);
			ft_memset(buf, 'E', 6);
			buf[6] = '\0';
			return(buf[7] != 'E');
		}, "too far... ft_memset(buf, 'E', 6)").msg();

		result += SupraTest.test(null, () => {
			uint8 buf[20];
			buf[5] = '\0';
			ft_memset(buf, 'E', 6);
			buf[6] = '\0';
			return(buf[5] == 'E');
		}, "ft_memset(buf, 'E', 6)").msg();

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

		result += SupraTest.test(null, () => {
			uint8 buf[20];
			return (ft_memset(buf, 'E', 6) == buf);
		}, "return value != buf ft_memset(buf, 'E', 6)").msg();

		result += SupraTest.test(null, () => {
			uint8 buf[20];
			return (ft_memset(buf, 'E', 0) == buf);
		}, "return value != buf ft_memset(buf, 'E', 0)").msg();

		// c is converted to unsigned char
		result += SupraTest.test(null, () => {
			uint8 buf[20];
			Memory.set(buf, '\0', buf.length);
			ft_memset(buf, 'A' + 256, 4);
			return ((string)buf == "AAAA");
		}, "ft_memset(buf, 'A' + 256, 4) != \"AAAA\"").msg();


		return result;
	}
	catch (Error e) {
		return @"$result \033[31m$(e.message)\033[0m";
	}
}
