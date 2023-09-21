[CCode (has_target = false)]
delegate string d_worker();
Loader loader;
extern void init_malloc();
extern void reset_malloc();
extern void show_leak();

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
			run_strrchr
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
			}
			loop.run();
		}
		catch (Error e) {
			printerr(e.message);
		}
	}

	async string worker(d_worker func) {
		bool finish = false;
		string? result = null;
		new Thread<void>("work", ()=>{
			result = func();
			finish = true;
		});

		while (finish == false) {
			Idle.add(worker.callback, Priority.LOW);
			yield;
		}
		return result;
	}


}

void main() {
	init_malloc();
	reset_malloc();
	malloc(5);
	free(null);
	free(null);
	free(null);
	free(null);
	free(null);
	free(null);
	show_leak();
	new LibftTester();
}
