string run_memchr() {
	var result = new StringBuilder("MEMCHR:   ");
	try {
		var ft_memchr= (d_memchr)loader.symbol("ft_memchr");
		char s[] = {0, 1, 2 ,3 ,4 ,5};

		// 1
		result.append(SupraTest.test(null, ()=>{
			return (ft_memchr(s, 0, 0) == null);
		}, @"memchr({0, 1, 2, 3, 4, 5}, 0, 0) == null").msg());

		// 2
		result.append(SupraTest.test(null, ()=>{
			return (ft_memchr(s, 0, 1) == s);
		}, @"memchr({0, 1, 2, 3, 4, 5}, 0, 1) == tab").msg());

		// 3
		result.append(SupraTest.test(null, ()=>{
			return (ft_memchr(s, 2, 3) == &s[2]);
		}, @"memchr({0, 1, 2, 3, 4, 5}, 2, 3) == &tab[2]").msg());

		// 4
		result.append(SupraTest.test(null, ()=>{
			return (ft_memchr(s, 6, 6) == null);
		}, @"memchr({0, 1, 2, 3, 4, 5}, 6, 6) == null").msg());

		// 5
		result.append(SupraTest.test(null, ()=>{
			return (ft_memchr(s, (2 + 256), 3) == &s[2]);
		}, @"memchr({0, 1, 2, 3, 4, 5}, (2 + 256), 3) == &tab[2]").msg());

		// 6
		result.append(SupraTest.test(null, () => {
			ft_memchr(null, 'e', 0);
			return true;
		}, "memchr(null, 'e', 0)").msg());

		// 7
		result.append(SupraTest.test(null, () => {
			ft_memchr(null, 'e', 1);
			return false;
		}, "No segfault with memchr(null, 'e', 1)").msg_need_segfault());
		

		return (owned)result.str;
	}
	catch (Error e) {
		return @"$(result.str) \033[31m$(e.message)\033[0m";
	}
}
