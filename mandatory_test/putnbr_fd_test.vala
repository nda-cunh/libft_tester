string run_putnbr_fd() {
	var result = new StringBuilder.sized(250);
	result.append("PUTNBRFD: ");
	try {
		var ft_putnbr_fd = (d_putnbr_fd)loader.symbol("ft_putnbr_fd");
		string check(int s, int fd) {
			var t = SupraTest.complex(3, () => {
				ft_putnbr_fd(s, fd);
				return false;
			});
			if (t.status == KO) {
				if (fd == 1 && t.stdout == @"$s" && t.stderr == "") {
					t.status = OK;
					return t.msg(@"putstr('$s', 1) you '$(t.stdout)' ");
				} else if (fd == -1 && t.stdout == "" && t.stderr == "") {
					t.status = OK;
					return t.msg(@"putstr('$s', 1) you '$(t.stdout)' ");
				} else if (fd != -1 && t.stdout == "" && t.stderr == @"$s") {
					t.status = OK;
					return t.msg(@"putstr('$s', 2) you '$(t.stderr)' ");
				}
			}
			return t.msg(@"putstr('$s', $fd) ");
		}
		for (int i = 1; i != 3; ++i)
		{
			result.append(check(-42, i));
			result.append(check(-11, i));
			result.append(check(-10, i));
			result.append(check(-9, i));
			result.append(check(-1, i));
			result.append(check(0, i));
			result.append(check(1, i));
			result.append(check(9, i));
			result.append(check(10, i));
			result.append(check(11, i));
			result.append(check(42, i));
		}
		result.append(check(0, -1));
		result.append(check(42, -1));
		return (owned)result.str;
	}
	catch (Error e) {
		return @"$(result.str) \033[31m$(e.message)\033[0m";
	}
}
