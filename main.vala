[CCode (has_target = false)]
delegate string d_worker();
Loader loader;

class LibftTester{

	private int finish_test;
	private MainLoop loop;
	private d_worker[]tab;

	public  LibftTester() {
		tab = {
			run_isalpha,
			run_isdigit,
			run_isalnum,
			run_isascii,
			run_isprint,
			run_strlen,
			run_memset,
			run_bzero,
			run_toupper,
			run_tolower,
			run_strchr,
			run_itoa,
			run_atoi,
			run_strrchr,
			run_strncmp,
			run_strnstr,
			run_memchr,
			run_memcmp,
			run_memcpy
		};
		this.run();
	}

	void run_part2() {
		print("\033[33m     <------------- [ PART 2 ] ------------->\n\033[0m");
		Idle.add((SourceFunc)loop.quit);
		loop.run();
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
		foreach(var i in tab) {
			worker.begin(i, (obj, res) => {
				print("%s\n", worker.end(res));
				finish_test++;
				if (finish_test == tab.length)
					loop.quit();
			});
			if (get_num_processors() <= 2) {
				Thread.usleep(10000);
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
			// loop.run();
			loader = new Loader("libft.so");
			run_part1();
			// run_part2();
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

void main() {
	print("\n--------------- [ LIBFT TESTER ] ---------------\n");
	print("CPU: [%u] ", get_num_processors());
	print("%s\n\n", get_num_processors() > 2 ? "\033[92mFast Mode enabled\033[0m" : "\033[91mFast Mode disabled\033[0m");
	new LibftTester();
	print("====================================================");
}
