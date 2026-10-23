string run_putendl_fd() {
	var result = new StringBuilder.sized(250);
	result.append("PUTENDLFD:");
	try {
		var ft_putendl_fd = (d_putendl_fd)loader.symbol("ft_putendl_fd");
		var shield = new SupraTest.Shield();
		shield.check(() => {
			ft_putendl_fd(null, -1);
			return true;
		}, "putendl_fd(NULL, -1)");
		result.append(shield.msg());

		string check(string s, int fd) {
			var t = SupraTest.complex(3, () => {
				ft_putendl_fd(s, fd);
				return false;
			});
			// fd -1 is invalid: nothing must be written anywhere
			string expected = (fd == -1) ? "" : @"$s\n";
			string want_out = (fd == 1) ? expected : "";
			string want_err = (fd == 2) ? expected : "";
			if (t.status == KO && t.stdout == want_out && t.stderr == want_err)
				t.status = OK;
			return t.msg("%s", @"putendl_fd(\"$(s.escape())\", $fd) You: stdout \"$(t.stdout.escape())\" stderr \"$(t.stderr.escape())\" Me: stdout \"$(want_out.escape())\" stderr \"$(want_err.escape())\" ");
		}
		result.append(check("abc", 1));
		result.append(check("abc", 2));
		result.append(check(" \f\r\n\t\v", 1));
		result.append(check(" \f\r\n\t\v", 2));
		result.append(check("abcdefghijklmnopqrstuvwxyz", 1));
		result.append(check("abcdefghijklmnopqrstuvwxyz", 2));
		result.append(check("v", 1));
		result.append(check("v", 2));
		result.append(check("please dont write", -1));
		result.append(check("", -1));
		result.append(check("", 1));
		result.append(check("", 2));
		return (owned)result.str;
	}
	catch (Error e) {
		return @"$(result.str) \033[31m$(e.message)\033[0m";
	}
}
