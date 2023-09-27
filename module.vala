
errordomain ErrLoader{
	NOT_FOUND,
	SYMBOL_NOTFOUND
}

class Loader {
	public Loader(string library) throws ErrLoader{
		handle = DLL.dlopen(library, DLL.RTLD.LAZY);
		if (handle == null && DLL.error() != null)
			throw new ErrLoader.NOT_FOUND(@"Can't found $library");
	}

	public void* symbol(string name) throws ErrLoader {
		void *ptr = DLL.dlsym(handle, name);
		if (ptr != null) {
			return ptr;
		}
		throw new ErrLoader.SYMBOL_NOTFOUND(@"$name not found\n");
	}
	private void* handle;
}
