[CCode (has_target = false)]
delegate string d_worker();
Loader loader;

class LibftTester : Object{

	public  LibftTester(string []args) throws Error {
		var libft = find_libft(args);
		loader = new Loader(libft);
	}

	// SupraLoading
	async void loading() {
		var n = 0;
		while (true) {
			Timeout.add (300, loading.callback);
			yield;
			switch (n) {
				case 0:
					print("\033[35mSupraLoading    \033[0m\r");
					break;
				case 1:
					print("\033[36mSupraLoading .  \033[0m\r");
					break;
				case 2:
					print("\033[37mSupraLoading .. \033[0m\r");
					break;
				case 3:
					print("\033[34mSupraLoading ...\033[0m\r");
					break;
				case 4:
					n = -1;
					break;
			}
			++n;
		}
	}


	async void run_part(d_worker[] tab_func) {
		uint max = get_num_processors();
		int work = 0;

		foreach(unowned var i in tab_func)
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




	public async void run(){
		// load function SupraLoading
		loading.begin();

		yield run_part1();
		yield run_part2();
	}

	async string worker(d_worker func) {
		var func_copy = func;
		// run the func to test in a thread
		var thread = new Thread<string>(null, ()=>{
			string result = func_copy();
			Idle.add(worker.callback);
			return result;
		});

		yield;
		return thread.join();
	}
}

async void main(string []args) {
	print("\n--------------- [ LIBFT TESTER ] ---------------\n");
	print("CPU: [%u] ", get_num_processors());
	print("%s\n\n", get_num_processors() > 2 ? "\033[92mFast Mode enabled\033[0m" : "\033[91mFast Mode disabled\033[0m");
	Log.set_default_handler(()=> {});
	Intl.setlocale();
	try {
		var tester = new LibftTester(args);
		yield tester.run();
	}
	catch (Error e) {
		printerr ("\033[31m[SupraTest]\033[0m %s", e.message);
	}
	print("\n====================================================\n");
}
