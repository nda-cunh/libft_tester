
namespace DLL{
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

	[CCode (cname = "dlopen", cheader_filename="dlfcn.h")]
	extern void* dlopen(string filename, DLL.RTLD flags);

	[CCode (cname = "dlsym")]
	extern void* dlsym(void* handle, string symbol);
	
	[CCode (cname = "dlclose")]
	extern void* dlclose(void* handle);

	[CCode (cname = "dlerror")]
	public string error();

	// [CCode (cname="void", free_function = "dlclose", cheader_filename = "dlfcn.h")]
	// [Compact]
	// public class dl{
		// [CCode (cname = "dlopen")]
		// public dl(string filename, RTLD flags);
		// [CCode (cname = "dlsym")]
		// public void *dlsym(string symbol);
	// }
}
