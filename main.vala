[CCode (has_target = false)]
public delegate string d_worker();
Loader loader;

class LibftTester {

	public LibftTester (string []args) throws Error {
		var libft = find_libft(args);
		loader = new Loader(libft);
	}

	/**
	 * SupraLoading animation
	 */
	async void loading () {
		// with unicode animation
		const string []frames = {
			"⠋", "⠙","⠹","⠸","⠼","⠴","⠦","⠧","⠇","⠏"
		};
		var n = 0;
		var c = 3;
		while (true) {
			Timeout.add (200, loading.callback);
			yield;
			print("\033[3%d;1mSupraLoading %s\033[0m\r", c, frames[n]);
			++n;
			++c;
			if (n == frames.length)
				n = 0;
			if (c == 7)
				c = 3;
		}
	}


	/**
	 * Run a part of test in parallel
	 * @param tab_func Array of function to test
	 */
	async void run_part (d_worker[] tab_func) {
		uint max = get_num_processors();
		int work = 0;

		foreach(unowned var i in tab_func)
		{
			++work;
			worker.begin(i, (obj, res) => {
				print("                                   \r");
				print("%s\n", worker.end(res));
				--work;
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

	async void run_part1 () {
		const d_worker []tab_func_p1 = {
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

	async void run_part2 () {
		const d_worker []tab_func_p2 = {
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


// 	                          888         888888b.
//                           888         888  "88b
//                           888         888  .88P
// 88888b.   8888b.  888d888 888888      8888888K.   .d88b.  88888b.  888  888 .d8888b
// 888 "88b     "88b 888P"   888         888  "Y88b d88""88b 888 "88b 888  888 88K
// 888  888 .d888888 888     888         888    888 888  888 888  888 888  888 "Y8888b.
// 888 d88P 888  888 888     Y88b.       888   d88P Y88..88P 888  888 Y88b 888      X88
// 88888P"  "Y888888 888      "Y888      8888888P"   "Y88P"  888  888  "Y88888  88888P'
// 888
// 888
// 888

	async void run_part_bonus () {
		const d_worker []tab_func_p2 = {
			run_lstnew,
			run_lstsize,
			run_lstadd_front,
			run_lstadd_back,
			run_lstlast,
			run_lstdelone,
			run_lstclear,
			run_lstiter,
			run_lstmap

		};
		print("\033[33m     <------------- [ Bonus ] ------------->\n\033[0m");
		yield run_part(tab_func_p2);
	}




	/**
	 * Run all test with a Loading animation
	 */
	public async void run () {
		// load function SupraLoading
		loading.begin();

		yield run_part1();
		yield run_part2();
		yield run_part_bonus();
	}



	async string worker (d_worker func) {
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
