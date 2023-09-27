
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

//   SUPRATEST 
public enum Status{
	OK = 0,
	KO = 1,
	TIMEOUT = 2,
	SIGILL = 4,
	SIGFPE = 8,
	SIGBUS = 10,
	SIGSEGV = 11,
	LEAK = 42
}

public struct SupraTest {
	public string? 	message;
	public string? 	stdout;
	public string? 	stderr;
	public string? 	stdin;
	public Status	status;
	int				alloc;
	int				free;

	public SupraTest(string message) {
		this.message = message;
		this.stdout = null;
		this.stderr = null;
		this.stdin = null;
		this.status = KO;
	}

	public string msg_ok() {
		return "\033[32m[OK]\033[0m";
	}

	public string msg_ko(string? msg = null) {
		return @"\033[31m[KO] $(msg ?? "")\033[0m";
	}

	public string msg() {
		if (status == LEAK)
			return @"\033[31m[LEAK] $(this.alloc) Alloc $(this.free) Free $(this.message)\033[0m";
		if (status == SIGILL)
			return @"\033[31m[SIGILL] $(this.message)\033[0m";
		else if (status == SIGFPE)
			return @"\033[31m[SIGFPE] $(this.message)\033[0m";
		else if (status == SIGBUS)
			return @"\033[31m[SIGBUS] $(this.message)\033[0m";
		else if (status == SIGSEGV)
			return @"\033[31m[SIGSEGV] $(this.message)\033[0m";
		else if (status == OK)
			return @"\033[32m[OK]\033[0m";
		else if (status == KO)
			return @"\033[31m[KO] $(this.message)\033[0m";
		else if (status == TIMEOUT)
			return @"\033[31m[TIMEOUT] $(this.message)\033[0m";
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
	
	public void remove_sig() {
		int tab[] = {4, 8, 10, 11};
		foreach (var i in tab) {
			Posix.signal(i, Posix.SIG_DFL);
		}
	}
}

namespace Test {
	[CCode (cname = "mkstemp", cheader_filename="stdlib.h")]
	extern int mkstemp(char *template);

	public delegate bool testFunction();

	[CCode (cname = "WEXITSTATUS", cheader_filename="sys/wait.h")]
		extern int exit_status(int status);

	public SupraTest test(uint timeout, testFunction func, string err_message = "") {
		SupraTest result = SupraTest(err_message);
		result.init_sig();
		uint8 template_stderr[20] = "/tmp/vala_XXXXXXXXX".data;
		int fd_err = mkstemp(template_stderr);
		if (fd_err < 0)
			Posix.perror("Erreur lors de la création du fichier temporaire");
		int status;
		var timer = new Timer();
		var pid = Posix.fork();
		reset_malloc();
		if (pid == 0) {
			Posix.dup2(fd_err, 2);
			Posix.close(fd_err);
			bool b = func();
			printerr("[SupraLeak] %d Free, %d Malloc\n", get_free_count(), get_malloc_count());
			if (b == true) {
				Posix.exit(0);
			}
			Posix.exit(1);
		}
		result.remove_sig();
		while (true) {
			if (0 != Posix.waitpid(pid, out status, Posix.WNOHANG))
				break;
			if ((uint)timer.elapsed() >= timeout){
				Posix.kill(pid, Posix.Signal.INT);
				break;
			}
		}
		Posix.close(fd_err);
		var stream = FileStream.open((string)template_stderr, "r");
		if (stream != null) {
			uint8 buf[2048];
			if (stream.read(buf) > 0) {
				var s = (string)buf;
				var sp = s.split("\n");
				foreach(var i in sp) {
					if ("[SupraLeak]" in i) {
						i.scanf("[SupraLeak] %d Free, %d Malloc", out result.free, out result.alloc);
					}else
						printerr(i);
				}
			}
		}

		FileUtils.unlink((string)template_stderr);
		result.status = (Status)exit_status(status);
		if ((uint)timer.elapsed() >= timeout)
			result.status = TIMEOUT;
		return result;
	}

	public SupraTest complex(uint timeout, testFunction func, string err_message = "") {
		SupraTest result = SupraTest(err_message);
		result.init_sig();
		var timer = new Timer();
		int status;

		uint8 template_stdout[20] = "/tmp/vala_XXXXXXXXX".data;
		int fd_out = mkstemp(template_stdout);
		if (fd_out < 0)
			Posix.perror("Erreur lors de la création du fichier temporaire");
		uint8 template_stderr[20] = "/tmp/vala_XXXXXXXXX".data;
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
		result.remove_sig();
		while (true) {
			if (0 != Posix.waitpid(pid, out status, Posix.WNOHANG))
				break;
			if ((uint)timer.elapsed() >= timeout) {
				Posix.kill(pid, Posix.Signal.INT);
				break;
			}
		}
		Posix.close(fd_out);
		Posix.close(fd_err);
		var stream1 = FileStream.open((string)template_stdout, "r");
		result.stdout = read_all(ref stream1);
		var stream2 = FileStream.open((string)template_stderr, "r");
		result.stderr = read_all(ref stream2);

		var sp = result.stderr.split("\n");
		foreach(var i in sp) {
			if ("[SupraLeak]" in i) {
				i.scanf("[SupraLeak] %d Free, %d Malloc", out result.free, out result.alloc);
				result.status = Status.LEAK;
				return result;
			}
		}
		FileUtils.unlink((string)template_stderr);
		FileUtils.unlink((string)template_stdout);
		result.status = (Status)exit_status(status);
		if ((uint)timer.elapsed() >= timeout)
			result.status = TIMEOUT;
		return result;
	}
}

