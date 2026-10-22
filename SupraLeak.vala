
private size_t g_alloc_bytes = 0;
private int g_alloc_count = 0;
private int g_free_count = 0;
private int g_fail_at = 0;
private int g_fail_saved = 0;
private bool g_has_failed = false;

public class SupraLeak : Object {
	public static size_t bytes{
		get {
			return g_alloc_bytes;
		}
	}
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

	public static bool has_failed {
		get {
			return g_has_failed;
		}
	}

	public static void fail_at(int n) {
		g_fail_at = n;
		if (n > 0)
			g_has_failed = false;
	}
	public static void send_null() {
		fail_at(1);
	}

	public static void pause() {
		g_fail_saved = g_fail_at;
		g_fail_at = 0;
	}
	public static void resume() {
		g_fail_at = g_fail_saved;
	}
	public static void reset() {
		g_alloc_count = 0;
		g_free_count = 0;
		g_alloc_bytes = 0;
	}
}


// Extern Function
[CCode (cname = "vala_malloc")]
public void* vala_malloc(void *ptr, size_t len) {
	if (g_fail_at > 0 && --g_fail_at == 0) {
		g_has_failed = true;
		return null;
	}
	g_alloc_count++;
	g_alloc_bytes += len;
	Memory.set(ptr, 'E', len + 8);
	Memory.set(&ptr[len + 8], '\0', 8);
	return ptr;
}

[CCode (cname = "vala_free")]
public void vala_free(void *ptr) {
	g_free_count++;
}
