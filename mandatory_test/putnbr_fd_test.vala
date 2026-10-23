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
			// fd -1 is invalid: nothing must be written anywhere
			string expected = (fd == -1) ? "" : @"$s";
			string want_out = (fd == 1) ? expected : "";
			string want_err = (fd == 2) ? expected : "";
			if (t.status == KO && t.stdout == want_out && t.stderr == want_err)
				t.status = OK;
			return t.msg("%s", @"putnbr_fd($s, $fd) You: stdout \"$(t.stdout.escape())\" stderr \"$(t.stderr.escape())\" Me: stdout \"$(want_out.escape())\" stderr \"$(want_err.escape())\" ");
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
