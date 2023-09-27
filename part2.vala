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
// ft_putstr_fd
// ft_putendl_fd
// ft_putnbr_fd
