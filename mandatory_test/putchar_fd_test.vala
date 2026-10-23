string run_putchar_fd() {
	var result = new StringBuilder.sized(250);
	result.append("PUTCHARFD:");
	try {
		var ft_putchar_fd = (d_putchar_fd)loader.symbol("ft_putchar_fd");
		string check(char c, int fd) {
			var t = SupraTest.complex(3, () => {
				ft_putchar_fd(c, fd);
				return false;
			});
			// fd -1 is invalid: nothing must be written anywhere
			string expected = (fd == -1) ? "" : c.to_string();
			string want_out = (fd == 1) ? expected : "";
			string want_err = (fd == 2) ? expected : "";
			if (t.status == KO && t.stdout == want_out && t.stderr == want_err)
				t.status = OK;
			return t.msg("%s", @"putchar_fd('$(c.to_string().escape())', $fd) You: stdout \"$(t.stdout.escape())\" stderr \"$(t.stderr.escape())\" Me: stdout \"$(want_out.escape())\" stderr \"$(want_err.escape())\" ");
		}
		/* 1 */ result.append(check('e', 1));
		/* 2 */ result.append(check('v', 2));
		/* 3 */ result.append(check('e', -1));

		return (owned)result.str;
	}
	catch (Error e) {
		return @"$(result.str) \033[31m$(e.message)\033[0m";
	}
}
