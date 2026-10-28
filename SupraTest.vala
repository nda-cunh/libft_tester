
public string read_all(string file) {
	try {
		string contents;
		FileUtils.get_contents(file, out contents);
		return contents;
	}
	catch (Error e) {
		warning ("Error reading file %s: %s", file, e.message);
		return "";
	}
}

/* C-like display of a string argument: "abc", or NULL */
public string quote(string? s) {
	if (s == null)
		return "NULL";
	return "\"%s\"".printf(s);
}

//   SUPRATEST
public enum Status {
	OK = 0,
	KO = 1,
	SIGINT = 2,
	TIMEOUT = 3,
	ABORTED = 6,
	SIGILL = 4,
	SIGFPE = 8,
	SIGBUS = 10,
	SIGSEGV = 11,
	LEAK = 42
}


namespace SupraTest{
	public struct Test {
		public string? 	message;
		public string? 	stdout;
		public string? 	stderr;
		public string? 	stdin;
		public Status	status;
		int				alloc;
		int				free;
		size_t			bytes;
		bool			malloc_failed;
		public int32	elapsed_time;

		public Test(string message) {
			this.message = message;
			this.stdout = null;
			this.stderr = null;
			this.stdin = null;
			this.status = KO;
			this.alloc = 0;
			this.free = 0;
			this.malloc_failed = false;
		}

		public unowned string msg_ok() {
			return "\033[32m[OK]\033[0m";
		}

		/**
		 * For tests that expect a crash (NULL arguments like the libc):
		 * a protected version is not wrong, so it is only a warning
		 */
		public string msg_need_segfault () {
			if (this.status == SIGSEGV || this.status == SIGBUS)
				return (this.msg_ok());
			if (this.status == OK || this.status == KO || this.status == LEAK)
				return (this.msg_warn());
			return (this.msg_err());
		}

		/**
		 * For undefined behaviour that the libc handles without crashing
		 * (NULL with a size of 0): a crash is only a warning
		 */
		public string msg_crash_warn (string? format = null) {
			if (this.status == SIGSEGV || this.status == SIGBUS)
				return this.msg_warn(format);
			return this.msg_err(format);
		}

		/**
		 * For undefined behaviour with no libc to copy (NULL in part 2):
		 * crashing and protecting are both fine, only a leak or a timeout is an error
		 */
		public string msg_crash_ok (string? format = null) {
			if (this.status == SIGSEGV || this.status == SIGBUS)
				return this.msg_ok();
			return this.msg_err(format);
		}

		public string msg_warn (string? format = null) {
			var s = format ?? this.message;
			return @"\033[33m[WARN] \033[93m$(s)\033[0m";
		}

		public string msg_ko (string? format = null) {
			var s = format ?? this.message;
			return @"\033[31m[KO] \033[91m$(s)\033[0m";
		}

		public string msg_err (string? format = null, ...) {
			string msg;

			if (format == null)
				msg = this.message;
			else
				msg = format.vprintf(va_list());

			if (this.stderr != "\0") {
				if (msg == "")
					msg = this.stderr;
				else
					msg += " " + this.stderr;
			}
			switch (status) {
				case LEAK:
					return @"\033[31m[LEAK] $(this.alloc) Alloc $(this.free) Free $(msg) \033[0m";
				case TIMEOUT:
					return @"\033[31m[TIMEOUT] $(msg)\033[0m";
				case SIGILL:
					return @"\033[31m[SIGILL] $(msg)\033[0m";
				case SIGFPE:
					return @"\033[31m[SIGFPE] $(msg)\033[0m";
				case SIGBUS:
					return @"\033[31m[SIGBUS] $(msg)\033[0m";
				case SIGSEGV:
					return @"\033[31m[SIGSEGV] $(msg)\033[0m";
				case ABORTED:
					return @"\033[31m[ABORTED] $(msg)\033[0m";
				case OK:
					return "\033[32m[OK]\033[0m";
				case KO:
					return msg_ko(msg);
				default:
					return "\033[31m[???]\033[0m";
			}
		}

		public string msg (string? format = null, ...) {
			string msg;

			if (format == null)
				msg = this.message;
			else
				msg = format.vprintf(va_list());

			switch (status) {
				case LEAK:
					return @"\033[31m[LEAK] $(this.alloc) Alloc $(this.free) Free $(msg)\033[0m";
				case TIMEOUT:
					return @"\033[31m[TIMEOUT] $(msg)\033[0m";
				case SIGILL:
					return @"\033[31m[SIGILL] $(msg)\033[0m";
				case SIGFPE:
					return @"\033[31m[SIGFPE] $(msg)\033[0m";
				case SIGBUS:
					return @"\033[31m[SIGBUS] $(msg)\033[0m";
				case SIGSEGV:
					return @"\033[31m[SIGSEGV] $(msg)\033[0m";
				case ABORTED:
					return @"\033[31m[ABORTED] $(msg)\033[0m";
				case OK:
					return @"\033[32m[OK]\033[0m";
				case KO:
					return msg_ko(msg);
				default:
					return @"\033[31m[???] \033[0m";
			}
		}

		public void print_result () {
			stdout.printf("%s", this.msg());
		}

		public void init_sig () {
			int tab[] = {4, 8, 10, 11};
			foreach (var i in tab) {
				Posix.signal(i, (sg) => {
						// only async-signal-safe functions in a signal handler
						Posix._exit(sg);
					});
			}
		}
	}
	/**
	 * NULL arguments of the non-libc functions (part 2 and 3) are undefined:
	 * crashing is fine and shows [  ], surviving every NULL case shows a shield.
	 * Only a leak or a timeout is an error.
	 */
	public class Shield {
		private bool all_protected = true;
		private StringBuilder errors = new StringBuilder();

		public void check(testFunction func, string message) {
			var t = SupraTest.test(null, func, message);
			if (t.status == SIGSEGV || t.status == SIGBUS)
				this.all_protected = false;
			else if (t.status != OK && t.status != KO)
				this.errors.append(t.msg_err());
		}

		public string msg() {
			if (this.errors.len > 0)
				return this.errors.str;
			if (this.all_protected)
				return "\033[36m[🛡️ ]\033[0m";
			return "\033[36m[  ]\033[0m";
		}
	}

	[CCode (cname = "mkstemp", cheader_filename="stdlib.h")]
	extern int mkstemp(char *template);

	public delegate bool testFunction();

	[CCode (cname = "WEXITSTATUS", cheader_filename="sys/wait.h")]
	extern int exit_status(int status);

	[CCode (cname = "poison_stack")]
	extern void poison_stack();

	[CCode (cname = "g_source_set_callback", cheader_filename = "glib.h")]
	extern void child_watch_set_callback(ChildWatchSource source, [CCode (type = "GSourceFunc")] owned ChildWatchFunc func);

	Status wait_child(Posix.pid_t child_pid, uint time) {
		var ctx = new MainContext();
		var loop = new MainLoop(ctx);
		Status status = KO;
		bool timed_out = false;

		var child_watch = new ChildWatchSource(child_pid);
		child_watch_set_callback(child_watch, (pid, wait_status) => {
			if (Process.if_exited(wait_status))
				status = (Status)exit_status(wait_status);
			else if (Process.if_signaled(wait_status))
				status = (Status)Process.term_sig(wait_status);
			loop.quit();
		});
		child_watch.attach(ctx);

		var timeout = new TimeoutSource.seconds(time);
		timeout.set_callback(() => {
			// the child watch still reaps it, no zombie
			Posix.kill(child_pid, Posix.Signal.KILL);
			timed_out = true;
			return Source.REMOVE;
		});
		timeout.attach(ctx);

		loop.run();
		timeout.destroy();
		if (timed_out)
			return TIMEOUT;
		return status;
	}

	public Test test(uint? timeout, testFunction func, string err_message = "") {
		uint time;
		if (timeout == null)
			time = 2;
		else
			time = timeout;
		Test result = Test(err_message);
		uint8 template_stderr[20] = "/tmp/vala_XXXXXXXXX".data;
		int fd_err = mkstemp(template_stderr);
		if (fd_err < 0)
			Posix.perror("Erreur lors de la création du fichier temporaire");


		// FORK
		var child_pid = Posix.fork();
		if (child_pid == 0) {

			poison_stack();

			result.init_sig();
			SupraLeak.reset();
			Posix.dup2(fd_err, 2);
			Posix.close(fd_err);
			bool b = func();
			if (SupraLeak.has_failed)
				stderr.printf("[SupraFail]\n");
			stderr.printf("[SupraLeak] %d Free, %d Malloc, %zu Bytes\n", SupraLeak.free, SupraLeak.malloc, SupraLeak.bytes);
			Posix.exit((b == true) ? 0 : 1);
		}

		Timer timer = new Timer();
		result.status = wait_child(child_pid, time);
		result.elapsed_time = (int32)(timer.elapsed() * 1000000);

		Posix.close(fd_err);
		result.stderr = read_all((string)template_stderr);

		// get SupraLeak alloc/free and remove it
		int index_leak = result.stderr.index_of("[SupraLeak]");
		// not found if the child crashed before printing it
		if (index_leak != -1) {
			unowned string begin = result.stderr.offset(index_leak);
			begin.scanf("[SupraLeak] %d Free, %d Malloc, %zu Bytes\n", ref result.free, ref result.alloc, ref result.bytes);
			result.stderr = result.stderr.replace(@"[SupraLeak] $(result.free) Free, $(result.alloc) Malloc, $(result.bytes) Bytes\n", "");
		}

		// the malloc armed with SupraLeak.fail_at() has been reached
		if (result.stderr.index_of("[SupraFail]\n") != -1) {
			result.malloc_failed = true;
			result.stderr = result.stderr.replace("[SupraFail]\n", "");
		}

		FileUtils.unlink((string)template_stderr);
		if (result.status == OK || result.status == KO) {
			if (result.free != result.alloc)
				result.status = LEAK;
		}
		return result;
	}


	public Test test_min_alloc(size_t min_bytes, testFunction func, string err_message = "") {
		Test result = test(null, func, err_message);
		if (result.status == OK && result.bytes < min_bytes) {
			result.status = KO;
			result.message = @"$(err_message) alloc $(result.bytes) bytes instead of at least $(min_bytes)";
		}
		return result;
	}

	public delegate bool mallocFunction(int n);

	public Test test_each_malloc(mallocFunction func, string err_message = "", int max = 64) {
		Test result = Test(err_message);
		for (int n = 1; n <= max; n++) {
			result = test(null, () => func(n), @"$(err_message)(malloc n°$(n) fail)");
			if (result.status == KO && result.stderr.strip() != "") {
				result.message = "";
				result.stderr = result.stderr.strip();
			}
			else if (result.status == KO && !result.malloc_failed)
				result.message = @"$(err_message)(returns NULL but no malloc failed)";
			else if (!result.malloc_failed)
				result.message = @"$(err_message)(no malloc failed)";
			if (result.status != OK || !result.malloc_failed)
				break;
		}
		return result;
	}



	public Test complex(uint timeout, testFunction func, string err_message = "") {
		Test result = Test(err_message);

		uint8 template_stdout[20] = "/tmp/vala_XXXXXXXXX".data;
		int fd_out = mkstemp(template_stdout);
		if (fd_out < 0)
			Posix.perror("Erreur lors de la création du fichier temporaire");
		uint8 template_stderr[20] = "/tmp/vala_XXXXXXXXX".data;
		int fd_err = mkstemp(template_stderr);
		if (fd_err < 0)
			Posix.perror("Erreur lors de la création du fichier temporaire");

		var child_pid = Posix.fork();
		if (child_pid == 0) {

			poison_stack();
			result.init_sig();
			SupraLeak.reset();
			Posix.dup2(fd_out, 1);
			Posix.dup2(fd_err, 2);
			Posix.close(fd_out);
			Posix.close(fd_err);
			bool res = func();
			stderr.printf("[SupraLeak] %d Free, %d Malloc, %zu Bytes\n", SupraLeak.free, SupraLeak.malloc, SupraLeak.bytes);
			if(res == true)
				Posix.exit(0);
			Posix.exit(1);
		}

		Timer timer = new Timer();
		result.status = wait_child(child_pid, timeout);
		result.elapsed_time = (int32)(timer.elapsed() * 1000000);

		Posix.close(fd_out);
		Posix.close(fd_err);
		result.stdout = read_all((string)template_stdout);
		result.stderr = read_all((string)template_stderr);

		// get SupraLeak alloc/free and remove it
		int index_leak = result.stderr.index_of("[SupraLeak]");
		// not found if the child crashed before printing it
		if (index_leak != -1) {
			unowned string begin = result.stderr.offset(index_leak);
			begin.scanf("[SupraLeak] %d Free, %d Malloc, %zu Bytes\n", ref result.free, ref result.alloc, ref result.bytes);
			result.stderr = result.stderr.replace(@"[SupraLeak] $(result.free) Free, $(result.alloc) Malloc, $(result.bytes) Bytes\n", "");
		}

		// remove stderr pipe
		FileUtils.unlink((string)template_stderr);
		FileUtils.unlink((string)template_stdout);

		if (result.free != result.alloc)
			result.status = LEAK;
		return result;
	}
}

