
public string read_all(string file) {
	var stream = FileStream.open(file, "r");
	if (stream == null)
		return "";
	var str = new StringBuilder();
	uint8 buff[8192];
	size_t len = 0;
	while((len = stream.read (buff)) >= 1)
		str.append ((string)buff[0:len]);
	return str.str;
}

//   SUPRATEST
public enum Status{
	OK = 0,
	KO = 1,
	SIGINT = 2,
	TIMEOUT = 3,
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

		public Test(string message) {
			this.message = message;
			this.stdout = null;
			this.stderr = null;
			this.stdin = null;
			this.status = KO;
			this.alloc = 0;
			this.free = 0;
		}

		public unowned string msg_ok() {
			return "\033[32m[OK]\033[0m";
		}

		public string msg_need_segfault() {
			if (this.status == SIGSEGV)
				return (this.msg_ok());
			else
				return (this.msg_ko());
		}

		public string msg_ko(string? msg = null) {
			var s = msg ?? this.message;
			return @"\033[31m[KO] \033[91m$(s)\033[0m";
		}

		public string msg_err(string? message = null) {
			var s = message ?? this.message;
			return msg(@"\033[91m$s $(this.stderr)\033[0m");
		}

		public string msg(string? message = null) {
			var msg = message ?? this.message;
			if (status == LEAK)
				return @"\033[31m[LEAK] $(this.alloc) Alloc $(this.free) Free $(msg)\033[0m";
			else if (status == TIMEOUT)
				return @"\033[31m[TIMEOUT] $(msg)\033[0m";
			else if (status == SIGILL)
				return @"\033[31m[SIGILL] $(msg)\033[0m";
			else if (status == SIGFPE)
				return @"\033[31m[SIGFPE] $(msg)\033[0m";
			else if (status == SIGBUS)
				return @"\033[31m[SIGBUS] $(msg)\033[0m";
			else if (status == SIGSEGV)
				return @"\033[31m[SIGSEGV] $(msg)\033[0m";
			else if (status == OK)
				return @"\033[32m[OK]\033[0m";
			else if (status == KO)
				return msg_ko(msg);
			else
				return @"\033[31m[???] \033[0m";
		}

		public void print_result() {
			print(this.msg());
		}

		public void init_sig(){
			int tab[] = {4, 8, 10, 11};
			foreach (var i in tab) {
				Posix.signal(i, (sg) => {
						Posix.exit(sg);
					});
			}
		}
	}
	[CCode (cname = "mkstemp", cheader_filename="stdlib.h")]
	extern int mkstemp(char *template);

	public delegate bool testFunction();

	[CCode (cname = "WEXITSTATUS", cheader_filename="sys/wait.h")]
	extern int exit_status(int status);

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

			// Write in STACK memory EEEEE
			{
				uint8 memory[8192];
				Memory.set(memory, 'E', 4046);
				Memory.set(&memory[4046], '\0', 4046);
			}

			result.init_sig();
			SupraLeak.reset();
			Posix.dup2(fd_err, 2);
			Posix.close(fd_err);
			bool b = func();
			stderr.printf("[SupraLeak] %d Free, %d Malloc, %zu Bytes\n", SupraLeak.free, SupraLeak.malloc, SupraLeak.bytes);
			Posix.exit((b == true) ? 0 : 1);
		}


		// Async waitpid
		var timer = new Timer();
		while (true) {
			int status;
			if (0 != Posix.waitpid(child_pid, out status, Posix.WNOHANG)) {
				result.status = (Status)exit_status(status);
				break;
			}
			if ((uint)timer.elapsed() >= time){
				Posix.kill(child_pid, Posix.Signal.INT);
				result.status = TIMEOUT;
				break;
			}
		}

		Posix.close(fd_err);
		result.stderr = read_all((string)template_stderr);

		// get SupraLeak alloc/free and remove it
		if (result.stderr != null) {
			unowned string begin = result.stderr.offset(result.stderr.index_of("[SupraLeak]"));
			begin.scanf("[SupraLeak] %d Free, %d Malloc, %zu Bytes\n", ref result.free, ref result.alloc, ref result.bytes);
			result.stderr = result.stderr.replace(@"[SupraLeak] $(result.free) Free, $(result.alloc) Malloc, $(result.bytes) Bytes\n", "");
		}

		FileUtils.unlink((string)template_stderr);
		if (result.status == OK || result.status == KO) {
			if (result.free != result.alloc)
				result.status = LEAK;
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

			// Write in STACK memory EEEEE
			{
				uint8 memory[8192];
				Memory.set(memory, 'E', 4046);
				Memory.set(&memory[4046], '\0', 4046);
			}
			result.init_sig();
			SupraLeak.reset();
			Posix.dup2(fd_out, 1);
			Posix.dup2(fd_err, 2);
			Posix.close(fd_out);
			Posix.close(fd_err);
			bool res = func();
			printerr("[SupraLeak] %d Free, %d Malloc, %zu Bytes\n", SupraLeak.free, SupraLeak.malloc, SupraLeak.bytes);
			Posix.close(fd_out);
			if(res == true)
				Posix.exit(0);
			Posix.exit(1);
		}


		// Async waitpid
		var timer = new Timer();
		while (true) {
			int status;
			if (0 != Posix.waitpid(child_pid, out status, Posix.WNOHANG)) {
				result.status = (Status)exit_status(status);
				break;
			}
			if ((uint)timer.elapsed() >= timeout){
				Posix.kill(child_pid, Posix.Signal.INT);
				result.status = TIMEOUT;
				break;
			}
		}

		Posix.close(fd_out);
		Posix.close(fd_err);
		result.stdout = read_all((string)template_stdout);
		result.stderr = read_all((string)template_stderr);

		// get SupraLeak alloc/free and remove it
		if (result.stderr != null) {
			unowned string begin = result.stderr.offset(result.stderr.index_of("[SupraLeak]"));
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

