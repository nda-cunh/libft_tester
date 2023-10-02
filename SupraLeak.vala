
private int g_alloc_count = 0;
private int g_free_count = 0;
private bool g_is_null = false;

public class SupraLeak {
	public static int free {
		get {
			return g_free_count;
		}
	}
	public static int malloc{
		get {
			return g_alloc_count;
		}
	}
	public static void send_null() {
		g_is_null = true;
	}
	public static void reset() {
		g_alloc_count = 0;
		g_free_count = 0;
	}
}


// Extern Function
[CCode (cname = "vala_malloc")]
public void* vala_malloc(void *ptr, size_t len) {
	if (g_is_null) {
		g_is_null = false;
		return null;
	}
	g_alloc_count++;
	return ptr;
}

[CCode (cname = "vala_free")]
public void vala_free(void *ptr) {
	g_free_count++;
}
