errordomain ErrLoader{
	NOT_FOUND,
	SYMBOL_NOTFOUND
}

class Loader {
	public Loader(string library) throws ErrLoader{
		mod = Module.open(library, ModuleFlags.LAZY);
		if ( mod == null )
			throw new ErrLoader.NOT_FOUND(@"Can't found $library");
	}
	public void* symbol(string name) throws ErrLoader {
		if (mod.symbol(name, out ptr_f)) {
			return ptr_f;
		}
		throw new ErrLoader.SYMBOL_NOTFOUND(@"$name not found");
	}
	private void* ptr_f;
	private Module mod;
}
