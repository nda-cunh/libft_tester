string run_memcmp() {
	string result = "MEMCMP:   ";
	try {
		var ft_memcmp = (d_memcmp)loader.symbol("ft_memcmp");
		string check(void *m1, void *m2, size_t len, string msg = ""){
			var t = SupraTest.test(null, ()=> {
				var y = ft_memcmp(m1, m2, len);
				var m = memcmp(m1, m2, len);
				if (clang_s(m) == clang_s(y))
					return true;
				stderr.printf("you: %d, Me: %d", y, m);
				return false;
			});
			string msg_dup;

			if (msg == ""){
				string s1;
				string s2;
				s1 = (string)m1;
				s2 = (string)m2;
				msg_dup = @"memcmp('$s1', '$s2', $len)";
			}
			else {
				msg_dup = msg;
			}

			return t.msg_err(msg_dup);
		}

		uint8 []p = {'t', 128, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};

		result += check("salut", "salut", 5);
		result += check(p, "t\0", 2, "memcmp('t\\200', 't\\0', 2)");
		result += check("testss", "test", 5);
		result += check("test", "tEst", 4);
		result += check("", "test", 4);
		result += check("test", "", 4);
		result += check("supra\0vim", "supra\0pack", 8, "memcmp('supra\\0vim', 'supra\\0pack', 8)");
		result += check("abcdefghij", "abcdefgxyz", 7);
		result += check("abcdefgh", "abcdwxyz", 6);
		result += check("zyxbcdefgh", "abcdefgxyz", 0);
	}
	catch (Error e) {
		return @"$result \033[31m$(e.message)\033[0m";
	}
	return result;
}
