string run_putchar_fd() {
	var result = new StringBuilder.sized(250);
	result.append("PUTCHARFD:");
	try {
		var ft_putchar_fd = (d_putchar_fd)loader.symbol("ft_putchar_fd");
		SupraTest.Test t;
		//test 1
		t = SupraTest.complex(3, () => {
			ft_putchar_fd('e', 1);
			return true;
		});
		if (t.status == OK && t.stdout == "e" && t.stderr == "")
			t.status = OK;
		result.append(t.msg(@"putchar('e', 1) you '$(t.stdout)' "));

		//test 2

		t = SupraTest.complex(3, () => {
			ft_putchar_fd('v', 2);
			return true;
		});
		if (t.status == OK && t.stdout == "" && t.stderr == "v")
			t.status = OK;
		result.append(t.msg(@"putchar('e', 2) you '$(t.stderr)' "));

		//test 3

		t = SupraTest.complex(3, () => {
			ft_putchar_fd('e', -1);
			return true;
		});
		if (t.status == OK && t.stdout == "" && t.stderr == "")
			t.status = OK;
		result.append(t.msg(@"putchar('e', -1) you '$(t.stderr)' "));

		return (owned)result.str;
	}
	catch (Error e) {
		return @"$(result.str) \033[31m$(e.message)\033[0m";
	}
}
