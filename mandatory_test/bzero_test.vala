string run_bzero() {
	var result = new StringBuilder.sized(300);
	result.append("BZERO:    ");
	try {
		var ft_bzero = (d_bzero)loader.symbol("ft_bzero");
		for (int i = 0; i < 25; ++i)
		{
			result.append(SupraTest.test(null, () => {
				uint8 buf1[128];
				uint8 buf2[128];
				Memory.set(buf1, 'X', 40);
				Memory.set(buf2, 'X', 40);

				ft_bzero(buf1, i);
				Memory.set(buf2, '\0', i);
				if (Memory.cmp(buf1, buf2, 38) == 0)
					return true;
				return false;
			}, @"bzero(mem, E, $i)").msg());
		}
		return (owned)result.str;
	}
	catch (Error e) {
		return @"$(result.str) \033[31m$(e.message)\033[0m";
	}
}
