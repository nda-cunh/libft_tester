[CCode (has_target = false)]
delegate string d_worker();
Loader loader;

class LibftTester{

	private int finish_test;
	private MainLoop loop;
	private d_worker[] tab_func_p1;
	private d_worker[] tab_func_p2;

	public  LibftTester() {
		tab_func_p1 = {
			run_isalpha,
			run_isdigit,
			// run_isalnum,
			// run_isascii,
			// run_isprint,
			// run_strlen,
			// run_memset,
			// run_bzero,
			// run_strlcat,
			// run_strlcpy,
			// run_memmove,
			// run_toupper,
			// run_tolower,
			// run_strchr,
			// run_atoi,
			// run_strrchr,
			run_strncmp,
			run_strnstr,
			run_memchr,
			run_memcmp,
			run_memcpy,
			run_calloc,
			run_strdup
		};
		this.run();
	}

	async void loading() {
		var n = 0;
		while (true) {
			Timeout.add(300, loading.callback);
			yield;
			if (n == 0)
				print("\033[35mSupraLoading    \033[0m\r");
			if (n == 1)
				print("\033[36mSupraLoading .  \033[0m\r");
			if (n == 2)
				print("\033[37mSupraLoading .. \033[0m\r");
			if (n == 3)
				print("\033[34mSupraLoading ...\033[0m\r");
			++n;
			if (n == 4)
				n = 0;
		}
	}

	void run_part1() {
		print("\033[33m     <------------- [ PART 1 ] ------------->\n\033[0m");
		foreach(var i in tab_func_p1) {
			worker.begin(i, (obj, res) => {
				print("                              \r");
				print("%s\n", worker.end(res));
				++finish_test;
				if (finish_test == tab_func_p1.length)
					loop.quit();
			});
			if (get_num_processors() <= 2) {
				MainContext.default().iteration(true);
				Posix.usleep(100000);
			}
		}
		loop.run();
	}
	
	void run_part2() {
		tab_func_p2 = {
			run_itoa,
			// run_split,
			// run_strjoin,
			// run_strtrim,
			// run_strmapi,
			// run_striteri,
			// run_substr,
			// run_putchar_fd,
			run_putstr_fd,
			run_putendl_fd,
			run_putnbr_fd,
		};
		print("\033[33m     <------------- [ PART 2 ] ------------->\n\033[0m");
		foreach(var i in tab_func_p2) {
			worker.begin(i, (obj, res) => {
				print("                              \r");
				print("%s\n", worker.end(res));
				++finish_test;
				if (finish_test == tab_func_p2.length)
					loop.quit();
			});
			if (get_num_processors() <= 2) {
				MainContext.default().iteration(true);
				Posix.usleep(100000);
			}
		}
		loop.run();
	}

	void run(){	
		try {
			loop = new MainLoop();
			Idle.add(()=> {
				loading.begin();
				return false;
			});
			loader = new Loader("libft.so");
			finish_test = 0;
			run_part1();
			finish_test = 0;
			run_part2();
		}
		catch (Error e) {
			printerr(e.message);
		}
	}

	async string worker(d_worker func) {
		string? result = null;
		var thread = new Thread<void>("work", ()=>{
			result = func();
			Idle.add(worker.callback);
		});

		yield;
		thread.join();
		return result;
	}
}

public const string p_supra= "\033[33;1m[SupraTester]\033[0m\033[37m ";
public const string p_none = "\033[0m";

void generate_so(string dir) {
	printerr("%sLibft found: %s\n%s", p_supra, dir, p_none);
	try {
		if (FileUtils.test(@"$dir/libft.so", FileTest.EXISTS))
			return ;
		if (FileUtils.test(@"$dir/Makefile", FileTest.EXISTS)) {
			var pid = new Subprocess.newv({"make", "so", "-C", @"$dir/"}, SubprocessFlags.STDERR_SILENCE); 
			pid.wait();
			if (pid.get_status() != 0) {
				printerr("%sLa regle 'so' n'existe pas dans le Makefile%s\n", p_supra, p_none);
				printerr("%s", p_supra);
				printerr("""
exemple d'une regle `so`
```makefile
so:
  gcc $(OBJS) --shared -o libft.so
```
	(Ca reviens a la regle avec ar -rc mais avec gcc et --shared)
Vous pouvez aussi juste cree le libft.so avec
```bash
	gcc *.c --shared -o libft.so
```
""");
				Posix.exit(0);
			}
		}
	} catch (Error e) {
		error(e.message);
	}
}

void libft_found(string []args) {
	if (Environment.get_variable("LD_LIBRARY_PATH") == null){
		var dir = Environment.get_current_dir();
		if (FileUtils.test(@"$dir/libft.so", FileTest.EXISTS)) {
			Environment.set_variable("LD_LIBRARY_PATH", "./", true);
		}
		else if (FileUtils.test(@"$dir/libft", FileTest.IS_DIR)) {
			Environment.set_variable("LD_LIBRARY_PATH", "./libft", true);
			generate_so(@"$dir/libft");
		}
		else if (FileUtils.test(@"$dir/../Makefile", FileTest.EXISTS)) {
			Environment.set_variable("LD_LIBRARY_PATH", "../", true);
			generate_so(@"$dir/..");
		}
		Posix.execv(args[0], args);
	}
}

void main(string []args) {
	libft_found(args);
	print("\n--------------- [ LIBFT TESTER ] ---------------\n");
	print("CPU: [%u] ", get_num_processors());
	print("%s\n\n", get_num_processors() > 2 ? "\033[92mFast Mode enabled\033[0m" : "\033[91mFast Mode disabled\033[0m");
	// Remove Vala DEBUGING LOG
	Log.set_default_handler(()=> {});
	new LibftTester();
	print("====================================================");
}

