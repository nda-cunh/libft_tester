[Flags]
[CCode (cname = "int", cprefix = "RTLD_")]
public enum RTLD {
	LAZY,
	NOW,
	GLOBAL,
	LOCAL,
	NODELETE,
	NOLOAD,
	DEEPBIND
}

[Flags]
[CCode (cname = "int", cprefix = "RTLD_DI_", cheader_filename="dlfcn.h")]
public enum RTLD_DI {
	LMID, // (Lmid_t *)
	LINKMAP, // (struct link_map **)
	ORIGIN, // (char *)
	SERINFO, // (Dl_serinfo *)
	SERINFOSIZE, // (Dl_serinfo *)
	TLS_MODID, // (size_t *, since glibc 2.4)
	TLS_DATA //(void **, since glibc 2.4)
}

[CCode (cname="void", free_function = "dlclose", cheader_filename = "dlfcn.h")]
[Compact]
public class Module {
	[CCode (cname = "dlopen")]
	public Module(string filename, RTLD flags);
	[CCode (cname = "dlsym")]
	public void *dlsym(string symbol);
	[CCode (cname = "dlerror")]
	private static string _error();
	[CCode (cname = "dlinfo")]
	int info(RTLD_DI request, void *p);
	public string error(){
		return _error();
	}
}
