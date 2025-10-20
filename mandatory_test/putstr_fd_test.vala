string run_putstr_fd() {
	var result = new StringBuilder.sized(250);
	result.append("PUTSTRFD: ");
	try {
		var ft_putstr_fd = (d_putstr_fd)loader.symbol("ft_putstr_fd");
		string check(string s, int fd) {
			var t = SupraTest.complex(3, () => {
				ft_putstr_fd(s, fd);
				return false;
			});
			if (t.status == KO) {
				if (fd == 1 && t.stdout == s && t.stderr == "") {
					t.status = OK;
					return t.msg(@"putstr('$s', 1) you '$(t.stdout)' ");
				} else if (fd == -1 && t.stdout == "" && t.stderr == "") {
					t.status = OK;
					return t.msg(@"putstr('$s', 1) you '$(t.stdout)' ");
				} else if (fd != -1 && t.stdout == "" && t.stderr == s) {
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
