[CCode (has_target = false)]
delegate string d_itoa(int n);
string run_itoa() {
	string result = "ITOA: ";
	Test.Console console = {};
	try {
		var ft_itoa = (d_itoa)loader.symbol("ft_itoa");
		try { Test.output(2, ref console, () => { return (ft_itoa(2147483647) == "2147483647"); }, "int MAX"); }catch (Test.TestValue e) { result += e.message; }
		try { Test.memory(2, () => { return (ft_itoa(-2147483648) == "-2147483648"); }, "int MIN"); }catch (Test.TestValue e) { result += e.message; }
		try { Test.memory(2, () => { return (ft_itoa(0) == "0"); }, "0"); }catch (Test.TestValue e) { result += e.message; }
		try { Test.memory(2, () => { return (ft_itoa(1) == "1"); }, "1"); }catch (Test.TestValue e) { result += e.message; }
		try { Test.memory(2, () => { return (ft_itoa(2) == "2"); }, "2"); }catch (Test.TestValue e) { result += e.message; }
		try { Test.memory(2, () => { return (ft_itoa(9) == "9"); }, "9"); }catch (Test.TestValue e) { result += e.message; }
		try { Test.memory(2, () => { return (ft_itoa(10) == "10"); }, "10"); }catch (Test.TestValue e) { result += e.message; }
		try { Test.memory(2, () => { return (ft_itoa(11) == "11"); }, "11"); }catch (Test.TestValue e) { result += e.message; }
		try { Test.memory(2, () => { return (ft_itoa(42) == "42"); }, "42"); }catch (Test.TestValue e) { result += e.message; }
		try { Test.memory(2, () => { return (ft_itoa(-1) == "-1"); }, "-1"); }catch (Test.TestValue e) { result += e.message; }
		try { Test.memory(2, () => { return (ft_itoa(-2) == "-2"); }, "-2"); }catch (Test.TestValue e) { result += e.message; }
		try { Test.memory(2, () => { return (ft_itoa(-9) == "-9"); }, "-9"); }catch (Test.TestValue e) { result += e.message; }
		try { Test.memory(2, () => { return (ft_itoa(-10) == "-10"); }, "-10"); }catch (Test.TestValue e) { result += e.message; }
		try { Test.memory(2, () => { return (ft_itoa(-11) == "-11"); }, "-11"); }catch (Test.TestValue e) { result += e.message; }
		try { Test.memory(2, () => { return (ft_itoa(-42) == "-42"); }, "-42"); }catch (Test.TestValue e) { result += e.message; }
		try { Test.memory(2, () => { return (ft_itoa(165468465) == "165468465"); }, "165468465"); }catch (Test.TestValue e) { result += e.message; }
		for (int N = 0; N < 5; ++N)
		{
			try {
				var i = Random.int_range(int.MIN, int.MAX);
				Test.memory(2, () => { return (ft_itoa(i) == @"$i"); }, @"random test $i");
			}catch (Test.TestValue e) { result += e.message; }
		}
		return result;
	}
	catch (Error e) {
		return @"$result \033[31m$(e.message)\033[0m";
	}
}
