string run_calloc() {
	string result = "CALLOC:   ";
	try {
		var ft_calloc = (d_calloc)loader.symbol("ft_calloc");

		SupraTest.Test t;

		/* 1 */ t = SupraTest.test(null, () => {
			char *m = ft_calloc(52, sizeof(char));
			if (m == null)
				return false;
			for (int i = 0; i < 52; ++i)
			{
				if (m[i] != '\0') {
					stderr.printf("byte %d is not 0", i);
					delete m;
					return false;
				}
			}
			delete m;
			return (true);
		}, "calloc(52, 1)");
		if (t.status == OK && t.alloc != 1)
			result += t.msg_ko(@"calloc(52, 1) $(t.alloc) malloc instead of 1");
		else
			result += t.msg_err();

		/* 2 */ result += SupraTest.test(null, () => {
			uint8 *m = ft_calloc(13, 4);
			if (m == null)
				return false;
			for (int i = 0; i < 52; ++i) {
				if (m[i] != 0) {
					stderr.printf("byte %d is not 0 (only nmemb bytes zeroed?)", i);
					free(m);
					return false;
				}
			}
			free(m);
			return true;
		}, "calloc(13, 4)").msg_err();

		/* 3 */ result += SupraTest.test_min_alloc(52, ()=>{
			void *mem = ft_calloc(13, 4);
			if (mem == null)
				return false;
			free(mem);
			return true;
		}, "calloc(13, 4)").msg_err();

		/* 4 */ result += SupraTest.test(null, ()=>{
			SupraLeak.send_null();
			char *s = ft_calloc(42, 1);
			if (s != null)
				delete s;
			return (s == null);
		}).msg_err("no protect malloc (send null) ");


		// subject: if nmemb or size is 0, return a unique pointer that can be passed to free()
		string check_zero(size_t nmemb, size_t size) {
			return SupraTest.test(null, ()=>{
				void *a = ft_calloc(nmemb, size);
				void *b = ft_calloc(nmemb, size);
				bool ok = (a != null && b != null && a != b);
				if (!ok)
					stderr.printf("You: %p and %p Me: 2 different pointers, not NULL", a, b);
				free(a);
				free(b);
				return ok;
			}, @"calloc($nmemb, $size)").msg_err();
		}
		/* 5 */ result += check_zero(0, 1);
		/* 6 */ result += check_zero(1, 0);
		/* 7 */ result += check_zero(0, 0);

		// nmemb * size overflows: must return NULL, not a tiny block
		string check_overflow(size_t nmemb, size_t size, string msg) {
			return SupraTest.test(null, () => {
				void *mem = ft_calloc(nmemb, size);
				if (mem != null) {
					free(mem);
					return false;
				}
				return true;
			}, msg).msg_err();
		}
		/* 8 */ result += check_overflow(size_t.MAX / 2 + 2, 2, "calloc(SIZE_MAX / 2 + 2, 2) overflow != NULL ");
		/* 9 */ result += check_overflow(size_t.MAX / 4 + 1, 8, "calloc(SIZE_MAX / 4 + 1, 8) overflow != NULL ");
		/* 10 */ result += check_overflow(size_t.MAX, size_t.MAX, "calloc(SIZE_MAX, SIZE_MAX) overflow != NULL ");


		return result;
	}
	catch (Error e) {
		return @"$result \033[31m$(e.message)\033[0m";
	}
}
