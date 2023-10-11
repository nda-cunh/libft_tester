
public const string p_supra= "\033[33;1m[SupraTester]\033[0m\033[37m ";
public const string p_none = "\033[0m";

string? find_libft(string []args) {
	var pwd = Environment.get_current_dir();
	
	// search in folder pwd/../Makefile
	if (FileUtils.test(@"$pwd/../Makefile", FileTest.EXISTS)) {
		print("Makefile found here: %s\n", @"$pwd/../Makefile");
		return null;
	}

	// search in folder pwd/**/Makefile
	try {
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
	} catch (Error e) {
		printerr("%s\n", e.message);
	}
	return null;
}

void run_command(string []av) {
	try {
		SubprocessFlags flags = SEARCH_PATH_FROM_ENVP | STDERR_SILENCE | STDOUT_SILENCE;
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
		string []result = {"gcc"};
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

string? generate_libft_so (string dir_makefile) {
	print(@"$(p_supra)Makefile found here: %s/Makefile\n$p_none", dir_makefile);
	// Test run so
	run_command({"make", "so", "-C", dir_makefile});

	// Test if libft.so exist
	if (FileUtils.test(@"$dir_makefile/libft.so", FileTest.EXISTS))
		return @"$dir_makefile/libft.so";

	// Test with libft.a
	run_command({"make", "-C", dir_makefile});
	if (FileUtils.test(@"$dir_makefile/libft.a", FileTest.EXISTS)) {
		print(@"$p_supra[Generate] libft.so from libft.a\n$p_none");
		string libft_so = extract_libft_dll(@"$dir_makefile/libft.a");
		if (FileUtils.test(libft_so, FileTest.EXISTS))
			return libft_so;
	}
	printerr("%sLa regle 'so' n'existe pas dans le Makefile%s\n", p_supra, p_none);
	printerr("%s", p_supra);
	printerr("""
exemple d'une regle `so`
```makefile
so:
  gcc $(OBJS) --shared -o libft.so
```
	(Ca reviens a la regle avec ar -rc mais avec gcc et --shared)
Vous pouvez aussi juste cree le libft.so avec
```bash
	gcc *.c --shared -o libft.so
```""");
	printerr("\n\n");
	return null;
}
