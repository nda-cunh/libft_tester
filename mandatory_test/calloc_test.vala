string run_calloc() {
	string result = "CALLOC:   ";
	try {
		var ft_calloc = (d_calloc)loader.symbol("ft_calloc");

		SupraTest.Test t;

		/* 1 */ t = SupraTest.test(null, () => {
			char *m = ft_calloc(52, sizeof(char));

			for (int i = 0; i < 52; ++i)
			{
				if (m[i] != '\0') {
					delete m;
					return false;
				}
			}
			delete m;
			return (true);
		}, "calloc(52)");
		if (t.alloc != 1)
			result += t.msg_ko(@"No alloc ??? $(t.alloc)");
		else
			result += t.msg_ok();
		/* 2 */ result += t.msg();

		/* 3 */ result += SupraTest.test(null, ()=>{
			SupraLeak.send_null();
			char *s = ft_calloc(42, 1);
			if (s != null)
				delete s;
			return (s == null);
		}).msg_err("no protect malloc (send null) ");


		/* 4 */ t = SupraTest.test(null, ()=>{
			bool stats;
			void* mem = ft_calloc(0, 1);
			stats = (mem != null);
			free(mem);
			return (stats);
		});
		if (t.bytes == 0)
			result += t.msg_ok();
		else
			result += t.msg_ko("dont alloc with calloc(0, 1)");

		/* 5 */ t = SupraTest.test(null, ()=>{
			bool stats;
			void* mem = ft_calloc(1, 0);
			stats = (mem != null);
			free(mem);
			return (stats);
		});
		if (t.bytes == 0)
			result += t.msg_ok();
		else
			result += t.msg_ko("dont alloc with calloc(1, 0)");

		/* 6 */ t = SupraTest.test(null, ()=>{
			bool stats;
			void* mem = ft_calloc(0, 0);
			stats = (mem != null);
			free(mem);
			return (stats);
		});
		if (t.bytes == 0)
			result += t.msg_ok();
		else
			result += t.msg_ko("dont alloc with calloc(0, 0)");


		return result;
	}
	catch (Error e) {
		return @"$result \033[31m$(e.message)\033[0m";
	}
}
