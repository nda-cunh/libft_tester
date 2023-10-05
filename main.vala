[CCode (has_target = false)]
delegate string d_worker();
Loader loader;

class LibftTester{
	
	private MainLoop loop;

	public  LibftTester(string []args) {
		try {
			loop = new MainLoop();
			var libft = find_libft(args);
			if (libft != null) {
				loader = new Loader(libft);
				this.run();
			}
			else {
				printerr("libft.so introuvable !\n");
			}
		}
		catch (Error e) {
			printerr(e.message);
		}
	}

	// SupraLoading
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



	async void run_part(d_worker[] tab_func) {
		const int max = 2;
		int work = 0;

		foreach(var i in tab_func)
		{
			work++;
			worker.begin(i, (obj, res) => {
				print("                              \r");
				print("%s\n", worker.end(res));
				work--;
			});

			while (work == max) {
				Idle.add(run_part.callback);
				yield;
			}
		}
		while (work != 0) {
		Idle.add(run_part.callback);
			yield;
		}
	}


                                      
	// ,------.                  ,--.    ,--.
	// |  .--. ' ,--,--.,--.--.,-'  '-. /   |
	// |  '--' |' ,-.  ||  .--''-.  .-' `|  |
	// |  | --' \ '-'  ||  |     |  |    |  |
	// `--'      `--`--'`--'     `--'    `--'

	async void run_part1() {
		d_worker []tab_func_p1 = {
			run_isalpha,
			run_isdigit,
			run_isalnum,
			run_isascii,
			run_isprint,
			run_strlen,
			run_memset,
			run_bzero,
			run_strlcat,
			run_strlcpy,
			run_memmove,
			run_toupper,
			run_tolower,
			run_strchr,
			run_atoi,
			run_strrchr,
			run_strncmp,
			run_strnstr,
			run_memchr,
			run_memcmp,
			run_memcpy,
			run_calloc,
			run_strdup
		};
		print("\033[33m     <------------- [ PART 1 ] ------------->\n\033[0m");
		yield run_part(tab_func_p1);
	}
	
	
	
	// ,------.                  ,--.    ,---.
	// |  .--. ' ,--,--.,--.--.,-'  '-. '.-.  \
	// |  '--' |' ,-.  ||  .--''-.  .-'  .-' .'
	// |  | --' \ '-'  ||  |     |  |   /   '-.
	// `--'      `--`--'`--'     `--'   '-----'
	
	async void run_part2() {
		d_worker []tab_func_p2 = {
			run_itoa,
			run_split,
			run_strjoin,
			run_strtrim,
			run_strmapi,
			run_striteri,
			run_substr,
			run_putchar_fd,
			run_putstr_fd,
			run_putendl_fd,
			run_putnbr_fd
		};
		print("\033[33m     <------------- [ PART 2 ] ------------->\n\033[0m");
		yield run_part(tab_func_p2);
	}




	void run(){
		// load function SupraLoading
		Idle.add(()=> {
			loading.begin();
			return false;
		});

		// load function Part 1 and Part 2 
		Idle.add(()=> {
			run_part1.begin(()=> {
				run_part2.begin(()=>{
					loop.quit();
				});
			});
			return false;
		});
		// Run async mode
		loop.run();
	}

	async string worker(d_worker func) {
		// run the func to test in a thread
		var thread = new Thread<string>("work", ()=>{
			string result = func();
			Idle.add(worker.callback);
			return result;
		});

		yield;
		return thread.join();
	}
}

void main(string []args) {
	print("\n--------------- [ LIBFT TESTER ] ---------------\n");
	print("CPU: [%u] ", get_num_processors());
	print("%s\n\n", get_num_processors() > 2 ? "\033[92mFast Mode enabled\033[0m" : "\033[91mFast Mode disabled\033[0m");
	Log.set_default_handler(()=> {});
	new LibftTester(args);
	print("====================================================\n");
}
