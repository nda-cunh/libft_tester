
public const string p_supra= "\033[33;1m[SupraTester]\033[0m\033[37m ";
public const string p_none = "\033[0m";

/**
 * Search for Makefile in common libft locations and generate libft.so
 * @return Path to generated libft.so
 * @throws Error if no Makefile is found or generation fails
 */
string? find_libft() throws Error {
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
	unowned string? name;

	while ((name = dir.read_name ()) != null) {
		var folder = Path.build_filename (pwd, name);
		if (FileUtils.test(folder, FileTest.IS_DIR)) {
			if (FileUtils.test(@"$folder/Makefile", FileTest.EXISTS)) {
				return generate_libft_so (folder);
			}
		}
	}
	throw new FileError.ACCES ("No Makefile found");
}

/**
 * Extract libft.a into a temporary folder and generate libft.so from object files
 * @param libft_a Path to libft.a
 * @return Path to generated libft.so
 * @throws Error if extraction or generation fails
 */
string extract_libft_dll (string libft_a) throws Error {
	string tmp_dir = DirUtils.make_tmp("vala_libsoXXXXXX");
	string error_str;
	int wait_status;

	Process.spawn_sync(tmp_dir,
		{"ar", "-xv", libft_a},
		null,
		SpawnFlags.SEARCH_PATH + SpawnFlags.STDOUT_TO_DEV_NULL,
		null,
		null,
		out error_str,
		out wait_status);

	if (wait_status != 0)
		throw new FileError.ACCES ("Can't extract object file from libft.a %s\n", error_str);

	Dir dir = Dir.open (tmp_dir);
	string result_so = Path.build_filename (tmp_dir, "libft.so");
	string []command = {"cc", "--shared", "-o", result_so};
	unowned string name;
	while ((name = dir.read_name ()) != null) {
		if (name.has_suffix(".o"))
			command += Path.build_filename (tmp_dir, name);
	}

	Process.spawn_sync(null,
		command,
		null,
		SpawnFlags.SEARCH_PATH + SpawnFlags.STDOUT_TO_DEV_NULL,
		null,
		null,
		out error_str,
		out wait_status);

	if (wait_status != 0)
		throw new FileError.ACCES ("Can't generate libft.so from object files %s\n", error_str);

	return result_so;
}

/**
  * Run make in the given directory to generate libft.a and libft.so
  * @param dir_makefile Directory containing the Makefile
  * @return Path to generated libft.so
  * @throws Error if make fails or libft.so cannot be generated
  */
public string? generate_libft_so (string dir_makefile) throws Error {
	stdout.printf(p_supra + "Makefile found here: %sMakefile" + p_none + "\n", dir_makefile);

	string errput;
	int wait_status;
	SpawnFlags flags = SpawnFlags.SEARCH_PATH + SpawnFlags.STDOUT_TO_DEV_NULL;
	Process.spawn_sync(null, {"make", "all", "-C", dir_makefile}, null, flags, null, null, out errput, out wait_status); 
	Process.spawn_sync(null, {"make", "bonus", "-C", dir_makefile}, null, flags, null, null); 


	if (wait_status != 0) {
		stderr.printf(p_supra + "Error while running make in %s\n" + p_none, dir_makefile);
		stderr.printf(p_supra + "\033[0m%s%s\n", errput, p_none);
		stderr.printf(p_supra + "Do you want running your last libft.a ? [y/N]");

		if (FileUtils.test(@"$dir_makefile/libft.a", FileTest.EXISTS)) {
			if (stdin.read_line().strip().ascii_down() != "y")
				throw new FileError.ACCES ("Error while running make");
		}	
	}

	// Generate libft.so from libft.a
	stderr.printf(p_supra + "[Generate] libft.so from libft.a\n" + p_none);
	string libft_so = extract_libft_dll(@"$dir_makefile/libft.a");
	if (FileUtils.test(libft_so, FileTest.EXISTS))
		return libft_so;
	throw new FileError.ACCES ("Can't generate libft.so from libft.a ???\n");
}
