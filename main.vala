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
			run_memcmp
		};
		this.run();
	}

	void run(){	
		try {
			loop = new MainLoop();
			loader = new Loader("libft.so");
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
	print("CPU: %u\n", get_num_processors());

	// var t = Test.test_output(1, ()=> {
		// return false;
	// }, "abc");
	// print("status: [%d]\n", t.status);
	// t.print_result();


	new LibftTester();
	print("====================================================");
}
