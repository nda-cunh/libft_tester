
public string read_all(ref FileStream stream) {
	var str = new StringBuilder();
	uint8 buff[8192];
	size_t len = 0;
	while((len = stream.read (buff)) >= 1)
		str.append ((string)buff[0:len]);
	return str.str;
}

extern int get_free_count();
extern int get_malloc_count();
extern void reset_malloc();

namespace Test {
	[CCode (cname = "mkstemp", cheader_filename="stdlib.h")]
	extern int mkstemp(char *template);
	public errordomain TestValue{
		TIMEOUT,
		FAILURE,
		OK,
		KO
	}

	public struct Console {
		string? stdout;
		string? stderr;
	}

	public delegate bool testFunction();
	public void simple(uint timeout, testFunction func, string err_message = "") throws TestValue {
		int status;
		var timer = new Timer();
		var pid = Posix.fork();
		reset_malloc();
		if (pid == 0) {
			bool b = func();
			if (get_free_count() != get_malloc_count())
				printerr("[SupraLeak] %d Free <,> %d Malloc\n", get_free_count(), get_malloc_count());
			if (b == true) {
				Posix.exit(0);
			}
			Posix.exit(1);
		}
		while (true) {
			if (0 != Posix.waitpid(pid, out status, Posix.WNOHANG))
				break;
			if ((uint)timer.elapsed() >= timeout) {
				throw new TestValue.TIMEOUT(@"\033[31m[TIMEOUT] $(err_message)\033[0m");
			}
		}
		if (status == 0)
			throw new TestValue.OK("\033[32m[OK]\033[0m");
		else
			throw new TestValue.KO(@"\033[31m[KO] $(err_message)\033[0m");
	}


	public void memory(uint timeout, testFunction func, string err_message = "") throws TestValue {
		Console console = {};
		output(timeout, ref console, func, err_message);
	}

	public void output(uint timeout, ref Console console, testFunction func, string err_message = "") throws TestValue {
		var timer = new Timer();
		console = {};
		int status;

		uint8 template_stdout[20] = "/tmp/vala_XXXXXXXXX".data;
		uint8 template_stderr[20] = "/tmp/vala_XXXXXXXXX".data;
		int fd_out = mkstemp(template_stdout);
		if (fd_out < 0)
			Posix.perror("Erreur lors de la création du fichier temporaire");
		int fd_err = mkstemp(template_stderr);
		if (fd_err < 0)
			Posix.perror("Erreur lors de la création du fichier temporaire");

		var pid = Posix.fork();
		reset_malloc();
		if (pid == 0) {
			Posix.dup2(fd_out, 1);
			Posix.dup2(fd_err, 2);
			Posix.close(fd_out);
			Posix.close(fd_err);
			bool res = func();
			if (get_free_count() != get_malloc_count())
				printerr("[SupraLeak] %d Free, %d Malloc\n", get_free_count(), get_malloc_count());
			Posix.close(fd_out);
			if(res == true)
				Posix.exit(0);
			Posix.exit(1);
		}
		while (true) {
			if (0 != Posix.waitpid(pid, out status, Posix.WNOHANG))
				break;
			if ((uint)timer.elapsed() >= timeout) {
				throw new TestValue.TIMEOUT(@"\033[31m[TIMEOUT] $(err_message)\033[0m");
			}
		}
		Posix.close(fd_out);
		Posix.close(fd_err);
		var stream1 = FileStream.open((string)template_stdout, "r");
		console.stdout = read_all(ref stream1);
		var stream2 = FileStream.open((string)template_stderr, "r");
		console.stderr = read_all(ref stream2);

		var sp = console.stderr.split("\n");
		foreach(var i in sp) {
			if ("[SupraLeak]" in i) {
				int f;
				int m;
				i.scanf("[SupraLeak] %d Free, %d Malloc", out f, out m);
				throw new TestValue.KO(@"\033[31;1m[LEAK]\033[31;2m: $m Alloc $f Free ($err_message)\033[0m");
			}
		}
		if (status == 0)
			throw new TestValue.OK("\033[32m[OK]\033[0m");
		else
			throw new TestValue.KO(@"\033[31m[KO] $(err_message)\033[0m");
	}
}

// void main () {
	// 
	// try {
		// Console console = {};
		// Test.output(5, ref console, ()=> {
			// stdout.printf("OUT");
			// stderr.printf("ERR");
			// return (5 == 5);
		// });
		// print("Output: [%s]\n", console.stdout);
		// print("Errout: [%s]\n", console.stderr);
// 
	// }catch (TestValue e) {
		// print(e.message);
	// }
// }
