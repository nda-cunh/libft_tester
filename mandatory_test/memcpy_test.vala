string run_memcpy() {
	string result = "MEMCPY:   ";
	try {
		var ft_memcpy = (d_memcpy)loader.symbol("ft_memcpy");

		result += SupraTest.test(null, () => {
			const string dest1 = "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
			const string dest2 = "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
			var r = ft_memcpy(dest1, "coucou", 0);
			Memory.copy(dest2, "coucou", 0);
			if (r != dest1) {
				stderr.printf("Return is not 'dest' ");
				return false;
			}
			if (Memory.cmp(dest1.data, dest2.data, 30) != 0) {
				stderr.printf("Memory is not 'AAAAAAAAAAA' ");
				return false;
			}
			return true;
		}, "memcpy(dest, 'coucou', 0) ").msg_err();

		result += SupraTest.test(null, () => {
			const string dest = "AAAAAAAAAA";
			var r = memcpy(dest.data, null, 0);
			if (r != dest) {
				stderr.printf("Return is not 'dest' ");
				return false;
			}
			if (Memory.cmp(dest.data, "AAAAAAAAAA", 10) != 0) {
				stderr.printf("Memory is not 'AAAAAAAAAAA' ");
				return false;
			}

			return true;
		}, "memcpy(dest, NULL, 0) ").msg_err();


		result += SupraTest.test(null, () => {
			const int size = 100;
			const string src = "\0\0abc";
			uint8 dest1[size + 1];
			uint8 dest2[size + 1];
			Memory.set(dest1, 'A', size);
			Memory.set(dest2, 'A', size);
			dest1[size] = '\0';
			dest2[size] = '\0';
			var r =ft_memcpy(dest1, src, 2);
			Memory.copy(dest2, src, 2);
			if (r != dest1) {
				stderr.printf("Return is not 'dest' ");
				return false;
			}
			if (Memory.cmp(dest1, dest2, size) != 0) {
				stderr.printf("\n>>> you: '%s' me %s ", (string)dest1, (string)dest2);
				return false;
			}
			return true;
		}, """ft_memcpy("AAAAAAAAAAAAAA...(100)", "\0\0abc", 2)""").msg_err();


		result += SupraTest.test(null, () => {
			const int size = 100;
			const string src = "Hello, World!";
			uint8 dest1[size + 1];
			uint8 dest2[size + 1];
			dest1[size] = '\0';
			dest2[size] = '\0';
			Memory.set(dest1, 'A', size);
			Memory.set(dest2, 'A', size);
			var r =ft_memcpy(dest1, src, 12);
			Memory.copy(dest2, src, 12);
			if (r != dest1) {
				stderr.printf("Return is not 'dest' ");
				return false;
			}
			if (Memory.cmp(dest1, dest2, size) != 0) {
				stderr.printf("\n>>> you: '%s' me %s ", (string)dest1, (string)dest2);
				return false;
			}
			return true;
		}, """ft_memcpy("AAAAAAAAAAAAAA...(100)", "Hello, World!", 12)""").msg_err();

		result += SupraTest.test(null, () => {
			const int size = 100;
			const string src = "abcdefghijklmnopqrstuvwxyz0123456789zyxwvutsrqponmlkjihgfedcba";
			uint8 dest1[size + 1];
			uint8 dest2[size + 1];
			Memory.set(dest1, 'A', size);
			Memory.set(dest2, 'A', size);
			dest1[size] = '\0';
			dest2[size] = '\0';
			var r =ft_memcpy(dest1, src, 61);
			Memory.copy(dest2, src, 61);
			if (r != dest1) {
				stderr.printf("Return is not 'dest' ");
				return false;
			}
			if (Memory.cmp(dest1, dest2, size) != 0) {
				stderr.printf("\n>>> you: '%s' me %s ", (string)dest1, (string)dest2);
				return false;
			}
			return true;
		}, """ft_memcpy("AAAAAAAAAAAAAA...(100)", "abcdefghijklmnopqrstuvwxyz0123456789zyxwvutsrqponmlkjihgfedcba, World!", 61)""").msg_err();


		result += SupraTest.test(null, () => {
			const int size = 42;
			const string src = "abcdefghijklmnopqrstuvwxyz0123456789zyxwvutsr\0";
			uint8 dest1[size + 1];
			uint8 dest2[size + 1];
			Memory.set(dest1, 'A', size);
			Memory.set(dest2, 'A', size);
			dest1[size] = '\0';
			dest2[size] = '\0';
			int i = 0;
			while (i != size) {
				void *r = null;
				r = ft_memcpy(dest1, src, i);
				Memory.copy(dest2, src, i);
				if (r != dest1) {
					stderr.printf("\n (loop: %d)>>> Your return is bad", i);
					return false;
				}
				if (Memory.cmp(dest1, dest2, size) != 0) {
					stderr.printf("\n(loop: %d)>>> you: '%s' me %s ", i, (string)dest1, (string)dest2);
					return false;
				}
				++i;
			}
			return true;
		}, """ft_memcpy("AAAAAAAAAAAAAA...(100)", "abcdefghijklmnopqrstuvwxyz0123456789zyxwvutsr", [[(loop 0->42)]]""").msg_err();

	}
	catch (Error e) {
		return @"$result \033[31m$(e.message)\033[0m";
	}
	return result;
}
