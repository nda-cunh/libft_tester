string run_memmove() {
	string result = "MEMMOVE:  ";
	try {
		var ft_memmove = (d_memmove)loader.symbol("ft_memmove");

		// compare ft_memmove with the libc memmove on the same buffer
		string check(int dst_off, int src_off, size_t n, string msg) {
			return SupraTest.test(null, () => {
				uint8 b1[65];
				uint8 b2[65];
				for (int i = 0; i < 64; ++i) {
					b1[i] = (uint8)('A' + i % 26);
					b2[i] = (uint8)('A' + i % 26);
				}
				b1[64] = '\0';
				b2[64] = '\0';
				var r = ft_memmove(&b1[dst_off], &b1[src_off], n);
				Memory.move(&b2[dst_off], &b2[src_off], n);
				if (r != &b1[dst_off]) {
					stderr.printf("Return is not 'dest' ");
					return false;
				}
				if (Memory.cmp(b1, b2, 64) != 0) {
					stderr.printf("you: \"%s\" me: \"%s\" ", (string)b1, (string)b2);
					return false;
				}
				return true;
			}).msg_err(msg);
		}

		/* 1 */ result += check(7, 0, 14, "overlap dest > src (buf + 7, buf, 14)");
		/* 2 */ result += check(2, 0, 14, "overlap dest > src (buf + 2, buf, 14)");
		/* 3 */ result += check(1, 0, 40, "overlap dest > src (buf + 1, buf, 40)");
		/* 4 */ result += check(0, 7, 14, "overlap dest < src (buf, buf + 7, 14)");
		/* 5 */ result += check(0, 2, 14, "overlap dest < src (buf, buf + 2, 14)");
		/* 6 */ result += check(0, 1, 40, "overlap dest < src (buf, buf + 1, 40)");
		/* 7 */ result += check(0, 32, 20, "different memory (buf, buf + 32, 20)");
		/* 8 */ result += check(40, 0, 20, "different memory (buf + 40, buf, 20)");
		/* 9 */ result += check(5, 5, 10, "same pointer (buf + 5, buf + 5, 10)");
		/* 10 */ result += check(3, 10, 0, "n = 0 (buf + 3, buf + 10, 0)");
		/* 11 */ result += check(10, 3, 0, "n = 0 (buf + 10, buf + 3, 0)");

		return result;
	}
	catch (Error e) {
		return @"$result \033[31m$(e.message)\033[0m";
	}
}
