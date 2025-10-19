
public const string p_supra= "\033[33;1m[SupraTester]\033[0m\033[37m ";
public const string p_none = "\033[0m";

string? find_libft(string []args) throws Error {
	var pwd = Environment.get_current_dir();
	
	// search in folder pwd/Makefile
	if (FileUtils.test(@"$pwd/Makefile", FileTest.EXISTS)) {
		var folder = @"$pwd/";
		if (FileUtils.test(@"$folder/Makefile", FileTest.EXISTS)) {
			return generate_libft_so (folder);
		}
	}

	// search in folder pwd/../libft/Makefile
	if (FileUtils.test(@"$pwd/../libft/Makefile", FileTest.EXISTS)) {
		var folder = @"$pwd/../libft/";
		if (FileUtils.test(@"$folder/Makefile", FileTest.EXISTS)) {
			return generate_libft_so (folder);
		}
	}
	
	// search in folder pwd/../Makefile
	if (FileUtils.test(@"$pwd/../Makefile", FileTest.EXISTS)) {
		var folder = @"$pwd/../";
		if (FileUtils.test(@"$folder/Makefile", FileTest.EXISTS)) {
			return generate_libft_so (folder);
		}
	}

	// search in folder pwd/**/Makefile
	var dir = Dir.open(pwd);
	unowned string? name = null;

	while ((name = dir.read_name ()) != null) {
		var folder = @"$pwd/$name";
		if (FileUtils.test(folder, FileTest.IS_DIR)) {
			if (FileUtils.test(@"$folder/Makefile", FileTest.EXISTS)) {
				return generate_libft_so (folder);
			}
		}
	}
	throw new FileError.ACCES ("No Makefile found");
}

void run_command(string []av) {
	try {
		SubprocessFlags flags = STDERR_SILENCE | STDOUT_SILENCE;
		var pid = new Subprocess.newv(av, flags); 
		pid.wait();
	} catch (Error e) {
		error(e.message);
	}
}

string extract_libft_dll(string libft_a) {
	string tmp_dir;
	try {
		tmp_dir = DirUtils.make_tmp("vala_libsoXXXXXX");
		run_command({"ar", "-xv", libft_a, @"--output=$tmp_dir"});
		Dir dir = Dir.open (tmp_dir);
		string []result = {"cc"};
		string name;
		while ((name = dir.read_name ()) != null) {
			if (name.has_suffix(".o"))
				result += @"$tmp_dir/$name";
		}
		result += "--shared";
		result += "-o";
		result += @"$tmp_dir/libft.so";
		run_command(result);
		return @"$tmp_dir/libft.so";
	} catch(Error e) {
		printerr(@"$(e.message)\n");
		return "";
	}
}

string? generate_libft_so (string dir_makefile) throws Error {
	print(@"$(p_supra)Makefile found here: %s/Makefile\n$p_none", dir_makefile);

	// Test with libft.a
	string errput;
	int wait_status;
	SpawnFlags flags = SpawnFlags.SEARCH_PATH + SpawnFlags.STDOUT_TO_DEV_NULL;
	Process.spawn_sync(null, {"make", "-C", dir_makefile}, null, flags, null, null, out errput, out wait_status); 


	if (FileUtils.test(@"$dir_makefile/libft.a", FileTest.EXISTS)) {
		if (wait_status != 0) {
			printerr("%sError while running make in %s\n%s", p_supra, dir_makefile, p_none);
			printerr("%s\033[0m%s%s\n", p_supra, errput, p_none);
			print("%sDo you want running your last libft.a ? [y/N] %s", p_supra, p_none);
			if (stdin.read_line().strip().ascii_down() != "y")
				throw new FileError.ACCES ("Error while running make");
		}
		print(@"$p_supra[Generate] libft.so from libft.a\n$p_none");
		string libft_so = extract_libft_dll(@"$dir_makefile/libft.a");
		if (FileUtils.test(libft_so, FileTest.EXISTS))
			return libft_so;
	}
	else {
		if (wait_status != 0) {
			printerr("%sError while running make in %s\n%s", p_supra, dir_makefile, p_none);
			printerr("%s\033[0m%s%s\n", p_supra, errput, p_none);
			throw new FileError.ACCES ("Error while running make");
		}

	}
	printerr("\n\n");
	throw new FileError.ACCES ("Can't generate libft.so from libft.a\n");
}
