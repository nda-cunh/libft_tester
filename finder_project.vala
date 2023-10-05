
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

string? generate_libft_so (string dir_makefile) {
	print("Makefile found here: %s/Makefile\n", dir_makefile);
	try {
			var pid = new Subprocess.newv({"make", "so", "-C", dir_makefile}, SubprocessFlags.STDERR_SILENCE); 
			pid.wait();
			if (pid.get_status() != 0) {
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
```
""");
				Posix.exit(0);
		}
	} catch (Error e) {
		error(e.message);
	}
	if (FileUtils.test(@"$dir_makefile/libft.so", FileTest.EXISTS))
		return @"$dir_makefile/libft.so";
	return null;
}

/*
   void generate_so(string dir) {
	printerr("%sLibft found: %s\n%s", p_supra, dir, p_none);
	try {
		if (FileUtils.test(@"$dir/libft.so", FileTest.EXISTS))
			return ;
		if (FileUtils.test(@"$dir/Makefile", FileTest.EXISTS)) {
			var pid = new Subprocess.newv({"make", "so", "-C", @"$dir/"}, SubprocessFlags.STDERR_SILENCE); 
			pid.wait();
			if (pid.get_status() != 0) {
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
```
""");
				Posix.exit(0);
			}
		}
	} catch (Error e) {
		error(e.message);
	}
}*/
