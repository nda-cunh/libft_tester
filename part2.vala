[CCode (has_target = false)]
delegate string d_itoa(int n);
string run_itoa() {
	string result = "ITOA:     ";
	try {
		var ft_itoa = (d_itoa)loader.symbol("ft_itoa");
		result += Test.complex(2, () => { return (ft_itoa(2147483647) == "2147483647"); }, "int MAX").msg();
		result += Test.complex(2, () => { return (ft_itoa(-2147483648) == "-2147483648"); }, "int MIN").msg();
		result += Test.complex(2, () => { return (ft_itoa(0) == "0"); }, "0").msg();
		result += Test.complex(2, () => { return (ft_itoa(1) == "1"); }, "1").msg();
		result += Test.complex(2, () => { return (ft_itoa(2) == "2"); }, "2").msg();
		result += Test.complex(2, () => { return (ft_itoa(9) == "9"); }, "9").msg();
		result += Test.complex(2, () => { return (ft_itoa(10) == "10"); }, "10").msg();
		result += Test.complex(2, () => { return (ft_itoa(11) == "11"); }, "11").msg();
		result += Test.complex(2, () => { return (ft_itoa(42) == "42"); }, "42").msg();
		result += Test.complex(2, () => { return (ft_itoa(-1) == "-1"); }, "-1").msg();
		result += Test.complex(2, () => { return (ft_itoa(-2) == "-2"); }, "-2").msg();
		result += Test.complex(2, () => { return (ft_itoa(-9) == "-9"); }, "-9").msg();
		result += Test.complex(2, () => { return (ft_itoa(-10) == "-10"); }, "-10").msg();
		result += Test.complex(2, () => { return (ft_itoa(-11) == "-11"); }, "-11").msg();
		result += Test.complex(2, () => { return (ft_itoa(-42) == "-42"); }, "-42").msg();
		result += Test.complex(2, () => { return (ft_itoa(165468465) == "165468465"); }, "165468465").msg();
		for (int N = 0; N < 5; ++N)
		{
				var i = Random.int_range(int.MIN, int.MAX);
				result += Test.complex(2, () => { return (ft_itoa(i) == @"$i"); }, @"random test $i").msg();
		}
		return result;
	}
	catch (Error e) {
		return @"$result \033[31m$(e.message)\033[0m";
	}
}
