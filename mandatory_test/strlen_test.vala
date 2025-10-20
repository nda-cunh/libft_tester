string run_strlen() {
	var result = "STRLEN:   ";
	try {
		var ft_strlen = (d_strlen)loader.symbol("ft_strlen");
		/* 1 */ result += (SupraTest.test(null, () => { return (ft_strlen("1") == 1); }, "1").msg());
		/* 2 */ result += (SupraTest.test(null, () => { return (ft_strlen("12") == 2); }, "2").msg());
		/* 3 */ result += (SupraTest.test(null, () => { return (ft_strlen("123") == 3); }, "3").msg());
		/* 4 */ result += (SupraTest.test(null, () => { return (ft_strlen("1234") == 4); }, "4").msg());
		/* 5 */ result += (SupraTest.test(null, () => { return (ft_strlen("12345") == 5); }, "5").msg());
		/* 6 */ result += (SupraTest.test(null, () => { return (ft_strlen("   \t\t\t\r\n") == 8); }, "8 spaces").msg());
		/* 6 */ result += (SupraTest.test(null, () => { return (ft_strlen("abcdefghijklmnopqrdtuvwxyz") == 26); }, "abcdefghijklmnopqrdtuvwxyz").msg());
		/* 7 */
		result += (SupraTest.test(null, () => {
			ft_strlen(null);
			return false;
		}, "No segfault with strlen(null)").msg_need_segfault());
		return result;
	}
	catch (Error e) {
		return @"$(result) \033[31m$(e.message)\033[0m";
	}
}
