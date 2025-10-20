string run_putendl_fd() {
	var result = new StringBuilder.sized(250);
	result.append("PUTENDLFD:");
	try {
		var ft_putendl_fd = (d_putendl_fd)loader.symbol("ft_putendl_fd");
		string check(string s, int fd) {
			var t = SupraTest.complex(3, () => {
				ft_putendl_fd(s, fd);
				return false;
			});
			if (t.status == KO) {
				if (fd == 1 && t.stdout == @"$s\n" && t.stderr == "") {
					t.status = OK;
					return t.msg(@"putstr('$s', 1) you '$(t.stdout)' ");
				} else if (fd == -1 && t.stdout == "" && t.stderr == "") {
					t.status = OK;
					return t.msg(@"putstr('$s', 1) you '$(t.stdout)' ");
				} else if (fd != -1 && t.stdout == "" && t.stderr == @"$s\n") {
					t.status = OK;
					return t.msg(@"putstr('$s', 2) you '$(t.stderr)' ");
				}
			}
			return t.msg(@"putstr('$s', $fd) ");
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
