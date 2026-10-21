errordomain ErrLoader{
	NOT_FOUND,
	SYMBOL_NOTFOUND
}

class Loader {
	public Loader(string library) throws ErrLoader{
		mutex = Mutex();
		handle = new Module(library, RTLD.LAZY);
		if (handle == null)
			throw new ErrLoader.NOT_FOUND(@"Can't load $library: $(Module.error())");
		library_path = library;
	}

	public void* symbol(string name) throws ErrLoader {
		mutex.lock();
		void *ptr = handle.dlsym(name);
		if (ptr != null) {
			mutex.unlock();
			return ptr;
		}
		mutex.unlock();
		throw new ErrLoader.SYMBOL_NOTFOUND(@"$name not found");
	}
	public string library_path;
	private Mutex mutex;
	private Module handle;
}
