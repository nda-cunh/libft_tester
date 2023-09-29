[CCode (has_target = false)]
delegate string d_itoa(int n);
string run_itoa() {
	string result = "ITOA:     ";
	try {
		var ft_itoa = (d_itoa)loader.symbol("ft_itoa");
		string check(int n, string? msg = null) {
			return Test.test(8, () => {
				return (ft_itoa(n) == @"$n");
			}, msg ?? @"$n").msg();
		}
		result += check(2147483647, "INT MAX ");
		result += check(-2147483648, "INT MIN ");
		result += check(0);
		result += check(1);
		result += check(2);
		result += check(9);
		result += check(10);
		result += check(11);
		result += check(42);
		result += check(-1);
		result += check(-2);
		result += check(-9);
		result += check(-10);
		result += check(-11);
		result += check(-42);
		result += check(165468465);
		for (var N = 0; N < 5; ++N)
		{
			var i = Random.int_range(int.MIN, int.MAX);
			result += check(i);
		}
		return result;
	}
	catch (Error e) {
		return @"$result \033[31m$(e.message)\033[0m";
	}
}

// ft_substr
// ft_strjoin
// ft_strtrim
// ft_split
// ft_itoa
// ft_strmapi
// ft_striteri

// ft_putchar_fd
[CCode (has_target = false)]
delegate void d_putchar_fd(char c, int fd);
string run_putchar_fd() {
	string result = "PUTCHARFD:";
	try {
		var ft_putchar_fd = (d_putchar_fd)loader.symbol("ft_putchar_fd");
		SupraTest t;
		//test 1
		t = Test.complex(8, () => {
			ft_putchar_fd('e', 1);
			return true;
		});
		if (t.status == OK && t.stdout == "e" && t.stderr == "")
			t.status = OK;
		result += t.msg(@"putchar('e', 1) you '$(t.stdout)' ");
		
		//test 2
		
		t = Test.complex(8, () => {
			ft_putchar_fd('v', 2);
			return true;
		});
		if (t.status == OK && t.stdout == "" && t.stderr == "v")
			t.status = OK;
		result += t.msg(@"putchar('e', 2) you '$(t.stderr)' ");
		
		//test 3
		
		t = Test.complex(8, () => {
			ft_putchar_fd('e', -1);
			return true;
		});
		if (t.status == OK && t.stdout == "" && t.stderr == "")
			t.status = OK;
		result += t.msg(@"putchar('e', -1) you '$(t.stderr)' ");

		return result;
	}
	catch (Error e) {
		return @"$result \033[31m$(e.message)\033[0m";
	}
}
// ft_putstr_fd
[CCode (has_target = false)]
delegate size_t  d_putstr_fd(char *s, int fd);
string run_putstr_fd() {
	string result = "PUTSTRFD: ";
	try {
		var ft_putstr_fd = (d_putstr_fd)loader.symbol("ft_putstr_fd");
		SupraTest t;
		
		//test 1
		t = Test.complex(8, () => {
			return (ft_putstr_fd("abcdefghijklmnopqrstuvwxyz", 1) == 26);
		});
		if (t.status == KO && t.stdout == "abcdefghijklmnopqrstuvxyz" && t.stderr == "")
			t.status = OK;
		result += t.msg(@"putstr('abcdefghijklmnopqrstuvxyz', 1) you '$(t.stdout)' ");
		
		//test 2
		
		t = Test.complex(8, () => {
			return (ft_putstr_fd("abcdefghijklmnopqrstuvwxyz", 2) == 26);
		});
		if (t.status == KO && t.stdout == "" && t.stderr == "v")
			t.status = OK;
		result += t.msg(@"putstr('', 2) you '$(t.stderr)' ");
		
		//test 3
		
		t = Test.complex(8, () => {
			return (ft_putstr_fd("please dont write", -1) == 0);
		});
		if (t.status == KO && t.stdout == "" && t.stderr == "")
			t.status = OK;
		result += t.msg(@"putstr('please dont write', -1) you '$(t.stderr)' ");

		//test 4
		t = Test.complex(8, () => {
			return (ft_putstr_fd("", 1) == 0);
		});
		if (t.status == KO && t.stdout == "" && t.stderr == "")
			t.status = OK;
		result += t.msg(@"putstr('', 1) you '$(t.stdout)' ");
		
		//test 5
		t = Test.complex(8, () => {
			return (ft_putstr_fd("", 2) == 0);
		});
		if (t.status == KO && t.stdout == "" && t.stderr == "")
			t.status = OK;
		result += t.msg(@"putstr('', 2) you '$(t.stdout)' ");

		return result;
	}
	catch (Error e) {
		return @"$result \033[31m$(e.message)\033[0m";
	}
}
// ft_putendl_fd
[CCode (has_target = false)]
delegate size_t  d_putendl_fd(char *s, int fd);
string run_putendl_fd() {
	string result = "PUTENDLFD:";
	try {
		var ft_putendl_fd = (d_putendl_fd)loader.symbol("ft_putendl_fd");
		SupraTest t;
		
		//test 1
		t = Test.complex(8, () => {
			return (ft_putendl_fd("abcdefghijklmnopqrstuvwxyz", 1) == 27);
		});
		if (t.status == KO && t.stdout == "abcdefghijklmnopqrstuvxyz\n" && t.stderr == "")
			t.status = OK;
		result += t.msg(@"putendl('abcdefghijklmnopqrstuvxyz', 1) you '$(t.stdout)' ");
		
		//test 2
		
		t = Test.complex(8, () => {
			return (ft_putendl_fd("abcdefghijklmnopqrstuvwxyz", 2) == 27);
		});
		if (t.status == KO && t.stdout == "" && t.stderr == "abcdefghijklmnopqrstuvwxyz\n")
			t.status = OK;
		result += t.msg(@"putendl('abcdefghijklmnopqrstuvwxyz', 2) you '$(t.stderr)' ");
		
		//test 3
		
		t = Test.complex(8, () => {
			return (ft_putendl_fd("please dont write", -1) == 0);
		});
		if (t.status == KO && t.stdout == "" && t.stderr == "")
			t.status = OK;
		result += t.msg(@"putendl('please dont write', -1) you '$(t.stderr)' ");

		//test 4
		t = Test.complex(8, () => {
			return (ft_putendl_fd("", 1) == 1);
		});
		if (t.status == KO && t.stdout == "\n" && t.stderr == "")
			t.status = OK;
		result += t.msg(@"putendl('', 1) you '$(t.stdout)' ");
		
		//test 5
		t = Test.complex(8, () => {
			return (ft_putendl_fd("", 2) == 1);
		});
		if (t.status == KO && t.stdout == "" && t.stderr == "\n")
			t.status = OK;
		result += t.msg(@"putendl('', 2) you '$(t.stdout)' ");

		return result;
	}
	catch (Error e) {
		return @"$result \033[31m$(e.message)\033[0m";
	}
}
// ft_putnbr_fd
[CCode (has_target = false)]
delegate void d_putnbr_fd(int n, int fd);
string run_putnbr_fd() {
	string result = "PUTNBRFD: ";
	try {
		var ft_putnbr_fd = (d_putnbr_fd)loader.symbol("ft_putnbr_fd");
		string check(int nb, int fd) {
			var t = Test.complex(8, () => {
				ft_putnbr_fd(nb, 1);
				return true;
			});
			if (fd == 1) {
				if (t.status == OK && t.stdout == @"$nb" && t.stderr == "")
					t.status = OK;
			}
			if (fd == 2) {
				if (t.status == OK && t.stdout == "" && t.stderr == @"$nb")
					t.status = OK;
			}
			return t.msg(@"putnbr('e', 1) you '$(t.stdout)' ");
		}
		for (int i = 1; i != 3; ++i)
		{
			result += check(-42, i);
			result += check(-11, i);
			result += check(-10, i);
			result += check(-9, i);
			result += check(-1, i);
			result += check(0, i);
			result += check(1, i);
			result += check(9, i);
			result += check(10, i);
			result += check(11, i);
			result += check(42, i);
		}
		return result;
	}
	catch (Error e) {
		return @"$result \033[31m$(e.message)\033[0m";
	}
}
