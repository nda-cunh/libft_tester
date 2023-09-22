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
			Timeout.add(200, worker.callback);
			yield;
		}
		return result;
	}


}

void main() {
	print("\n\n\nBEGIN\n");
	new LibftTester();
	print("\n [[[[[[[[[ END ]]]]]]]]]\n");
	// print("%d\n", Posix.getpid());
	// Posix.sleep(50);
}
