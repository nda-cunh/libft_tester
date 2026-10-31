public const int NOT_FOUND = -1;
public const string baby_string = "kfjjmhjksgnhfjkdnhsjkldnhkffjdfdjkfjdfdjkggjdfdjkgmhjksgnhfjkdnhsjkldnhkffjdfdjkfjdfdjkggjdfdjkg";

namespace Versus {
	public const int SMALL_LEN = 32;
	public const int MID_LEN = 4096;
	public const int BIG_LEN = 1 << 20;
	public string SMALL_STRING;
	public string MID_STRING;
	public string BIG_STRING;
	public string BIG_COPY;
	public uint8[] DEST;
	public const string NEEDLE = "abcdefghijklmnopqrstuvwxyzA";
	public const char ABSENT = 'A';

	public void init_strings () {
		SMALL_STRING = gen_string (SMALL_LEN);
		MID_STRING = gen_string (MID_LEN);
		BIG_STRING = gen_string (BIG_LEN);
		BIG_COPY = gen_string (BIG_LEN);
		DEST = new uint8[BIG_LEN + 128];
	}

	string gen_string (int len) {
		var s = new StringBuilder.sized (len + 1);
		for (int i = 0; i < len; i++)
			s.append_c ((char)('a' + i % 26));
		return (owned) s.str;
	}
}

delegate void BenchCall ();

class Bench {
	public BenchCall call;
	public int iterations;

	public Bench (owned BenchCall call, int iterations) {
		this.call = (owned) call;
		this.iterations = iterations;
	}

	public int64 run_once () {
		return SupraTest.test(3, ()=> {
			for (int j = 0; j < iterations; j++)
				call ();
			return true;
		}).elapsed_time;
	}
}

const int RUNS = 5;

double fork_us = -1.0;

double per_call_ns (int64 best, int iterations) {
	double us = double.max ((double)best - fork_us, 0.001);
	return us * 1000.0 / iterations;
}

void duel (Bench a, Bench b, out double a_ns, out double b_ns) {
	if (fork_us < 0.0) {
		int64 empty = int64.MAX;
		for (int i = 0; i < RUNS; i++)
			empty = int64.min (empty, SupraTest.test(3, ()=> true).elapsed_time);
		fork_us = (double)empty;
	}
	int64 best_a = int64.MAX;
	int64 best_b = int64.MAX;
	for (int i = 0; i < RUNS; i++) {
		best_a = int64.min (best_a, a.run_once ());
		best_b = int64.min (best_b, b.run_once ());
	}
	a_ns = per_call_ns (best_a, a.iterations);
	b_ns = per_call_ns (best_b, b.iterations);
}

class LibValue {
	bool is_lib_c = false;
	Loader loader;
	Loader? bsd = null;

	public LibValue (string libft, bool is_lib_c = false) throws Error {
		this.is_lib_c = is_lib_c;
		loader = new Loader (libft);
		if (is_lib_c)
			bsd = new Loader ("libbsd.so.0");
	}

	private string name_function (string name) {
		if (is_lib_c)
			return name;
		return "ft_" + name;
	}

	private void* sym (string name) {
		try {
			return loader.symbol (name_function (name));
		}
		catch (Error e) {
			if (bsd == null)
				return null;
			try {
				return bsd.symbol (name);
			}
			catch (Error e) {
				return null;
			}
		}
	}

	public Bench[]? run (string name) {
		switch (name) {
			case "strlen":  return test_strlen ();
			case "memcpy":  return test_memcpy ();
			case "memset":  return test_memset ();
			case "bzero":   return test_bzero ();
			case "memmove": return test_memmove ();
			case "memchr":  return test_memchr ();
			case "memcmp":  return test_memcmp ();
			case "strchr":  return test_strchr ();
			case "strrchr": return test_strrchr ();
			case "strncmp": return test_strncmp ();
			case "strlcpy": return test_strlcpy ();
			case "strlcat": return test_strlcat ();
			case "strnstr": return test_strnstr ();
			case "strdup":  return test_strdup ();
			case "atoi":    return test_atoi ();
			default:        return null;
		}
	}

	const int MID_ITER = 20000;
	const int BIG_ITER = 100;
	const int SMALL_ITER = 1000000;

	Bench[]? test_strlen () {
		void *f = sym ("strlen");
		if (f == null)
			return null;
		var func = (d_strlen)f;
		char *small = (char *)Versus.SMALL_STRING;
		char *mid = (char *)Versus.MID_STRING;
		char *big = (char *)Versus.BIG_STRING;

		return {
			new Bench (()=> func (small), SMALL_ITER),
			new Bench (()=> func (mid), MID_ITER),
			new Bench (()=> func (big), BIG_ITER),
			new Bench (()=> func (big + 1), BIG_ITER)
		};
	}

	Bench[]? test_memcpy () {
		void *f = sym ("memcpy");
		if (f == null)
			return null;
		var func = (d_memcpy)f;
		void *dest = Versus.DEST;
		char *small = (char *)Versus.SMALL_STRING;
		char *mid = (char *)Versus.MID_STRING;
		char *big = (char *)Versus.BIG_STRING;

		return {
			new Bench (()=> func (dest, small, Versus.SMALL_LEN), SMALL_ITER),
			new Bench (()=> func (dest, mid, Versus.MID_LEN), MID_ITER),
			new Bench (()=> func (dest, big, Versus.BIG_LEN), BIG_ITER),
			new Bench (()=> func (dest, big + 1, Versus.BIG_LEN), BIG_ITER)
		};
	}

	Bench[]? test_memset () {
		void *f = sym ("memset");
		if (f == null)
			return null;
		var func = (d_memset)f;
		uint8 *dest = Versus.DEST;

		return {
			new Bench (()=> func (dest, 'x', Versus.SMALL_LEN), SMALL_ITER),
			new Bench (()=> func (dest, 'x', Versus.MID_LEN), MID_ITER),
			new Bench (()=> func (dest, 'x', Versus.BIG_LEN), BIG_ITER),
			new Bench (()=> func (dest + 1, 'x', Versus.BIG_LEN), BIG_ITER)
		};
	}

	Bench[]? test_bzero () {
		void *f = sym ("bzero");
		if (f == null)
			return null;
		var func = (d_bzero)f;
		uint8 *dest = Versus.DEST;

		return {
			new Bench (()=> func (dest, Versus.SMALL_LEN), SMALL_ITER),
			new Bench (()=> func (dest, Versus.MID_LEN), MID_ITER),
			new Bench (()=> func (dest, Versus.BIG_LEN), BIG_ITER),
			new Bench (()=> func (dest + 1, Versus.BIG_LEN), BIG_ITER)
		};
	}

	Bench[]? test_memmove () {
		void *f = sym ("memmove");
		if (f == null)
			return null;
		var func = (d_memmove)f;
		uint8 *dest = Versus.DEST;

		return {
			new Bench (()=> func (dest + 64, dest, Versus.SMALL_LEN), SMALL_ITER),
			new Bench (()=> func (dest + 64, dest, Versus.MID_LEN), MID_ITER),
			new Bench (()=> func (dest + 64, dest, Versus.BIG_LEN), BIG_ITER),
			new Bench (()=> func (dest + 65, dest, Versus.BIG_LEN), BIG_ITER)
		};
	}

	Bench[]? test_memchr () {
		void *f = sym ("memchr");
		if (f == null)
			return null;
		var func = (d_memchr)f;
		char *small = (char *)Versus.SMALL_STRING;
		char *mid = (char *)Versus.MID_STRING;
		char *big = (char *)Versus.BIG_STRING;

		return {
			new Bench (()=> func (small, Versus.ABSENT, Versus.SMALL_LEN), SMALL_ITER),
			new Bench (()=> func (mid, Versus.ABSENT, Versus.MID_LEN), MID_ITER),
			new Bench (()=> func (big, Versus.ABSENT, Versus.BIG_LEN), BIG_ITER),
			new Bench (()=> func (big + 1, Versus.ABSENT, Versus.BIG_LEN), BIG_ITER)
		};
	}

	Bench[]? test_memcmp () {
		void *f = sym ("memcmp");
		if (f == null)
			return null;
		var func = (d_memcmp)f;
		char *big = (char *)Versus.BIG_STRING;
		char *copy = (char *)Versus.BIG_COPY;

		return {
			new Bench (()=> func (big, copy, Versus.SMALL_LEN), SMALL_ITER),
			new Bench (()=> func (big, copy, Versus.MID_LEN), MID_ITER),
			new Bench (()=> func (big, copy, Versus.BIG_LEN), BIG_ITER),
			new Bench (()=> func (big + 1, copy + 1, Versus.BIG_LEN), BIG_ITER)
		};
	}

	Bench[]? test_strchr () {
		void *f = sym ("strchr");
		if (f == null)
			return null;
		var func = (d_strchr)f;
		char *small = (char *)Versus.SMALL_STRING;
		char *mid = (char *)Versus.MID_STRING;
		char *big = (char *)Versus.BIG_STRING;

		return {
			new Bench (()=> func (small, Versus.ABSENT), SMALL_ITER),
			new Bench (()=> func (mid, Versus.ABSENT), MID_ITER),
			new Bench (()=> func (big, Versus.ABSENT), BIG_ITER),
			new Bench (()=> func (big + 1, Versus.ABSENT), BIG_ITER)
		};
	}

	Bench[]? test_strrchr () {
		void *f = sym ("strrchr");
		if (f == null)
			return null;
		var func = (d_strrchr)f;
		char *small = (char *)Versus.SMALL_STRING;
		char *mid = (char *)Versus.MID_STRING;
		char *big = (char *)Versus.BIG_STRING;

		return {
			new Bench (()=> func (small, Versus.ABSENT), SMALL_ITER),
			new Bench (()=> func (mid, Versus.ABSENT), MID_ITER),
			new Bench (()=> func (big, Versus.ABSENT), BIG_ITER),
			new Bench (()=> func (big + 1, Versus.ABSENT), BIG_ITER)
		};
	}

	Bench[]? test_strncmp () {
		void *f = sym ("strncmp");
		if (f == null)
			return null;
		var func = (d_strncmp)f;
		char *big = (char *)Versus.BIG_STRING;
		char *copy = (char *)Versus.BIG_COPY;

		return {
			new Bench (()=> func (big, copy, Versus.SMALL_LEN), SMALL_ITER),
			new Bench (()=> func (big, copy, Versus.MID_LEN), MID_ITER),
			new Bench (()=> func (big, copy, Versus.BIG_LEN), BIG_ITER),
			new Bench (()=> func (big + 1, copy + 1, Versus.BIG_LEN), BIG_ITER)
		};
	}

	Bench[]? test_strlcpy () {
		void *f = sym ("strlcpy");
		if (f == null)
			return null;
		var func = (d_strlcpy)f;
		char *dest = (char *)Versus.DEST;
		char *small = (char *)Versus.SMALL_STRING;
		char *mid = (char *)Versus.MID_STRING;
		char *big = (char *)Versus.BIG_STRING;

		return {
			new Bench (()=> func (dest, small, Versus.SMALL_LEN + 1), SMALL_ITER),
			new Bench (()=> func (dest, mid, Versus.MID_LEN + 1), MID_ITER),
			new Bench (()=> func (dest, big, Versus.BIG_LEN + 1), BIG_ITER),
			new Bench (()=> func (dest, big + 1, Versus.BIG_LEN), BIG_ITER)
		};
	}

	Bench[]? test_strlcat () {
		void *f = sym ("strlcat");
		if (f == null)
			return null;
		var func = (d_strlcat)f;
		char *dest = (char *)Versus.DEST;
		char *small = (char *)Versus.SMALL_STRING;
		char *mid = (char *)Versus.MID_STRING;
		char *big = (char *)Versus.BIG_STRING;

		return {
			new Bench (()=> { dest[0] = '\0'; func (dest, small, Versus.SMALL_LEN + 1); }, SMALL_ITER),
			new Bench (()=> { dest[0] = '\0'; func (dest, mid, Versus.MID_LEN + 1); }, MID_ITER),
			new Bench (()=> { dest[0] = '\0'; func (dest, big, Versus.BIG_LEN + 1); }, BIG_ITER),
			new Bench (()=> { dest[0] = '\0'; func (dest, big + 1, Versus.BIG_LEN); }, BIG_ITER)
		};
	}

	Bench[]? test_strnstr () {
		void *f = sym ("strnstr");
		if (f == null)
			return null;
		var func = (d_strnstr)f;
		char *small = (char *)Versus.SMALL_STRING;
		char *mid = (char *)Versus.MID_STRING;
		char *big = (char *)Versus.BIG_STRING;
		char *needle = (char *)Versus.NEEDLE;

		return {
			new Bench (()=> func (small, needle, Versus.SMALL_LEN), SMALL_ITER),
			new Bench (()=> func (mid, needle, Versus.MID_LEN), MID_ITER),
			new Bench (()=> func (big, needle, Versus.BIG_LEN), BIG_ITER),
			new Bench (()=> func (big + 1, needle, Versus.BIG_LEN), BIG_ITER)
		};
	}

	Bench[]? test_strdup () {
		void *f = sym ("strdup");
		if (f == null)
			return null;
		var func = (d_strdup)f;
		char *small = (char *)Versus.SMALL_STRING;
		char *mid = (char *)Versus.MID_STRING;
		char *big = (char *)Versus.BIG_STRING;

		return {
			new Bench (()=> free (func (small)), SMALL_ITER),
			new Bench (()=> free (func (mid)), MID_ITER),
			new Bench (()=> free (func (big)), BIG_ITER),
			new Bench (()=> free (func (big + 1)), BIG_ITER)
		};
	}

	Bench[]? test_atoi () {
		void *f = sym ("atoi");
		if (f == null)
			return null;
		var func = (d_atoi)f;
		char *small = (char *)"42";
		char *min = (char *)"-2147483648";
		char *spaces = (char *)" \t\n\v\f\r+000000000012345";

		return {
			new Bench (()=> func (small), SMALL_ITER),
			new Bench (()=> func (min), SMALL_ITER),
			new Bench (()=> func (spaces), SMALL_ITER)
		};
	}
}


const string[] ROUNDS = {
	"strlen", "memcpy", "memset", "bzero", "memmove", "memchr", "memcmp", "strchr",
	"strrchr", "strncmp", "strlcpy", "strlcat", "strnstr", "strdup", "atoi"
};
const string[] SIZES = {"light", "medium", "max", "max+1"};
const string[] ATOI_INPUTS = {"short", "int_min", "spaces"};
const int BAR_LEN = 14;
const int BOX_WIDTH = 82;

string fmt_time (double ns) {
	if (ns < 1000.0)
		return "%.1f ns".printf (ns);
	if (ns < 1000000.0)
		return "%.2f µs".printf (ns / 1000.0);
	return "%.2f ms".printf (ns / 1000000.0);
}

string fmt_ratio (double ratio) {
	if (ratio >= 10.0)
		return "×%.0f".printf (ratio);
	return "×%.1f".printf (ratio);
}

string pad (string s, int width) {
	var b = new StringBuilder (s);
	for (int i = s.char_count (); i < width; i++)
		b.append_c (' ');
	return b.str;
}

string lpad (string s, int width) {
	var b = new StringBuilder ();
	for (int i = s.char_count (); i < width; i++)
		b.append_c (' ');
	b.append (s);
	return b.str;
}

double max_ratio;
double ko_ratio;
string me;
string opp;
bool vs_libc;

double health (double gap) {
	return double.max (0.0, 1.0 - Math.log (gap) / Math.log (max_ratio));
}

string bar (double fill, bool mirrored) {
	int cells = int.max (1, (int)(fill * BAR_LEN + 0.5));
	string color = "\033[31m";
	if (fill >= 0.999)
		color = "\033[1;32m";
	else if (fill >= 2.0 / 3.0)
		color = "\033[32m";
	else if (fill >= 1.0 / 3.0)
		color = "\033[33m";
	var empty = new StringBuilder ("\033[90m");
	for (int i = cells; i < BAR_LEN; i++)
		empty.append ("░");
	var full = new StringBuilder (color);
	for (int i = 0; i < cells; i++)
		full.append ("▓");
	if (mirrored)
		return empty.str + full.str + "\033[0m";
	return full.str + empty.str + "\033[0m";
}

string box_rule (string left, string right, string text, string color, bool centered) {
	int len = text.char_count ();
	int before = centered ? (BOX_WIDTH - 2 - len) / 2 : 1;
	int after = BOX_WIDTH - 2 - len - before;
	var s = new StringBuilder ("  " + left);
	for (int i = 0; i < before; i++)
		s.append ("─");
	s.append_printf ("%s%s\033[0m", color, text);
	for (int i = 0; i < after; i++)
		s.append ("─");
	s.append (right);
	return s.str;
}

void print_round_header (int n, string name) {
	print ("\n%s\n", box_rule ("╭", "╮", " ROUND %d ─ %s ".printf (n, name.up ()), "\033[1;33m", false));
	string left = me.up ();
	string right = opp.up ();
	int left_pad = 21 + (BAR_LEN - left.char_count ()) / 2;
	int mid_pad = 21 + BAR_LEN + 1 - left_pad - left.char_count ();
	print ("  %s\033[1m%s%s┃%s%s\033[0m\n", pad ("", left_pad), left, pad ("", mid_pad),
		pad ("", 1 + (BAR_LEN - right.char_count ()) / 2), right);
}


int line_winner (double ratio) {
	if (ratio > 1.05)
		return -1;
	if (ratio < 1.0 / 1.05)
		return 1;
	return 0;
}

string ratio_color (double ratio) {
	if (ratio < 1.0 / 1.05)
		return "\033[1;32m";
	if (ratio <= 1.05)
		return "\033[36m";
	if (ratio < Math.sqrt (ko_ratio))
		return "\033[32m";
	if (ratio < ko_ratio)
		return "\033[33m";
	return "\033[31m";
}

void print_line (string label, double ft, double c) {
	double ratio = ft / c;
	int winner = line_winner (ratio);
	double ft_fill = (winner == -1) ? health (ratio) : 1.0;
	double c_fill = (winner == 1) ? health (1.0 / ratio) : 1.0;
	string verdict;
	if (winner == 0)
		verdict = "\033[36m= draw\033[0m";
	else if (winner == 1)
		verdict = "\033[1;32m%s %s ▶\033[0m".printf (me, fmt_ratio (1.0 / ratio));
	else
		verdict = "%s◀ %s %s\033[0m".printf (ratio_color (ratio), opp, fmt_ratio (ratio));
	string ft_style = (winner == -1) ? "\033[90m" : "\033[1m";
	string c_style = (winner == 1) ? "\033[90m" : "\033[1m";

	print ("  %s%s%s\033[0m  %s \033[1m┃\033[0m %s  %s%s\033[0m   %s\n",
		pad (label, 9), ft_style, lpad (fmt_time (ft), 10), bar (ft_fill, true),
		bar (c_fill, false), c_style, lpad (fmt_time (c), 10), verdict);
}


StringBuilder recap;
double log_sum;
int log_count;

void recap_row (string name, string[] labels, double[]? ft, double[]? c) {
	recap.append_printf ("  %s", pad (name, 9));
	if (c == null) {
		recap.append ("\033[90mno contest\033[0m\n");
		return;
	}
	if (ft == null) {
		recap.append ("\033[1;31mFORFEIT\033[0m\n");
		return;
	}
	for (int i = 0; i < SIZES.length; i++) {
		if (i >= labels.length) {
			recap.append_printf ("\033[90m%s\033[0m", lpad ("─", 7));
			continue;
		}
		double ratio = ft[i] / c[i];
		string cell = (ratio < 1.0 / 1.05) ? "▲" + fmt_ratio (1.0 / ratio) : fmt_ratio (ratio);
		recap.append_printf ("%s%s\033[0m", ratio_color (ratio), lpad (cell, 7));
		log_sum += Math.log (ratio);
		log_count++;
	}
	recap.append_c ('\n');
}

int print_round (string name, string[] labels, double[]? ft, double[]? c) {
	recap_row (name, labels, ft, c);
	if (c == null) {
		print ("  \033[90m%s not found in %s\033[0m\n", name, opp);
		print ("%s\n", box_rule ("╰", "╯", " NO CONTEST ", "\033[1;90m", true));
		return 0;
	}
	if (ft == null) {
		print ("  \033[31mft_%s not found\033[0m\n", name);
		print ("%s\n", box_rule ("╰", "╯", " FORFEIT ─ %s WINS ".printf (opp.up ()), "\033[1;31m", true));
		return -1;
	}

	int ft_points = 0;
	int c_points = 0;
	double worst = 1.0;
	for (int i = 0; i < labels.length; i++) {
		double ratio = ft[i] / c[i];
		int w = line_winner (ratio);
		if (w == 1)
			ft_points++;
		else if (w == -1)
			c_points++;
		worst = double.max (worst, ratio);
		print_line (labels[i], ft[i], c[i]);
	}

	int winner = 0;
	if (ft_points > c_points)
		winner = 1;
	else if (c_points > ft_points)
		winner = -1;
	if (winner == 0)
		print ("%s\n", box_rule ("╰", "╯", " DRAW %d ─ %d ".printf (ft_points, c_points), "\033[1;36m", true));
	else if (winner == 1)
		print ("%s\n", box_rule ("╰", "╯", " 🏆 %s WINS %d ─ %d ".printf (me.up (), ft_points, c_points), "\033[1;32m", true));
	else {
		string ko = (worst >= ko_ratio) ? "  K.O. " : " ";
		print ("%s\n", box_rule ("╰", "╯", " %s WINS %d ─ %d%s".printf (opp.up (), c_points, ft_points, ko), "\033[1;31m", true));
	}
	return winner;
}


string rank (double gap) {
	if (gap <= 2.0)
		return "★★★★★  GLIBC KILLER";
	if (gap <= 10.0)
		return "★★★★☆  word-at-a-time";
	if (gap <= 50.0)
		return "★★★☆☆  clean";
	if (gap <= 150.0)
		return "★★☆☆☆  byte by byte";
	return "★☆☆☆☆  beginner";
}

string champ_box (string text, string color, int emoji) {
	int width = text.char_count () + emoji + 6;
	var line = new StringBuilder ();
	for (int i = 0; i < width; i++)
		line.append ("═");
	return "\n  %s╔%s╗\n  ║   %s   ║\n  ╚%s╝\033[0m\n\n".printf (color, line.str, text, line.str);
}

void print_recap (int opp_score, int me_score) {
	print ("\n\n  \033[1;33m══════════════ RECAP ══════════════\033[0m\n");
	print ("  \033[90m×N   %s is N times slower than %s\033[0m\n", me, opp);
	print ("  \033[32m▲×N\033[90m  %s is N times faster\033[0m\n\n", me);
	var head = new StringBuilder ("  " + pad ("", 9));
	foreach (unowned string size in SIZES)
		head.append (lpad (size, 7));
	print ("\033[1m%s\033[0m\n", head.str);
	print ("%s", recap.str);
	print ("\n  \033[1mROUNDS     %s %d ─ %d %s\033[0m\n", me, me_score, opp_score, opp);
	if (log_count > 0) {
		double gap = Math.exp (log_sum / log_count);
		print ("  \033[1mMEAN GAP   %s%s\033[0m\n", ratio_color (gap), fmt_ratio (gap));
		if (vs_libc)
			print ("  \033[1mLEVEL      \033[1;33m%s\033[0m\n", rank (gap));
	}
	if (me_score > opp_score)
		print ("%s", champ_box ("🏆  %s IS THE CHAMP".printf (me.up ()), "\033[1;32m", 1));
	else if (opp_score > me_score)
		print ("%s", champ_box ("💀  %s IS THE CHAMP".printf (opp.up ()), "\033[1;31m", 1));
	else
		print ("%s", champ_box ("DRAW  MATCH", "\033[1;36m", 0));
}

string opponent_name (string path) {
	var file = File.new_for_path (path);
	string name = file.get_basename ();
	if (FileUtils.test (path, FileTest.IS_DIR) == false) {
		int dot = name.last_index_of_char ('.');
		if (dot > 0)
			name = name.substring (0, dot);
		if (name == "libft")
			name = file.get_parent ().get_basename ();
	}
	if (name == "" || name == "." || name == "/" || name == me)
		name = "rival";
	if (name.char_count () > 12)
		name = name.substring (0, name.index_of_nth_char (12));
	return name;
}

LibValue load_opponent (string versus) throws Error {
	me = "libft";
	opp = "libc";
	vs_libc = true;
	max_ratio = 300.0;
	ko_ratio = 50.0;
	if (versus == "libc")
		return new LibValue ("libc.so.6", true);
	vs_libc = false;
	max_ratio = 20.0;
	ko_ratio = 5.0;
	string path = File.new_for_path (versus).get_path ();
	opp = opponent_name (path);
	if (FileUtils.test (path, FileTest.IS_DIR))
		return new LibValue (SupraFinder.build_so (path, "libft", true));
	if (!FileUtils.test (path, FileTest.EXISTS))
		throw new FileError.NOENT ("%s: no such file", versus);
	if (path.has_suffix (".a"))
		return new LibValue (SupraFinder.archive_to_so (path, "libft"));
	return new LibValue (path);
}

public void versus_mode (string versus) {
	LibValue val_me;
	LibValue val_opp;
	try {
		var libft = SupraFinder.find_and_build ("libft", {"libft"}, true);
		Versus.init_strings ();
		stdout.flush ();
		val_me = new LibValue (libft);
		val_opp = load_opponent (versus);
		print ("""
	███████╗██╗  ██╗██████╗ ██████╗  █████╗
	██╔════╝██║  ██║██╔══██╗██╔══██╗██╔══██╗
	███████╗██║  ██║██████╔╝██████╔╝███████║
	╚════██║██║  ██║██╔═══╝ ██╔══██╗██╔══██║
	███████║╚█████╔╝██║     ██║  ██║██║  ██║
	╚══════╝ ╚════╝ ╚═╝     ╚═╝  ╚═╝╚═╝  ╚═╝
	""");
		print ("            \033[1m%s  ⚔  %s\033[0m\n", me, opp);
	}
	catch (Error e) {
		stderr.printf ("\033[31m[SupraTest]\033[0m %s\n", e.message);
		return;
	}

	recap = new StringBuilder ();
	log_sum = 0.0;
	log_count = 0;
	int me_score = 0;
	int opp_score = 0;
	for (int i = 0; i < ROUNDS.length; i++) {
		unowned string name = ROUNDS[i];
		unowned string[] labels = (name == "atoi") ? ATOI_INPUTS : SIZES;
		print_round_header (i + 1, name);
		print ("  \033[90mfighting...\033[0m");
		stdout.flush ();
		var ft_bench = val_me.run (name);
		var c_bench = val_opp.run (name);
		double[]? ft = (ft_bench == null) ? null : new double[labels.length];
		double[]? c = (c_bench == null) ? null : new double[labels.length];
		if (ft != null && c != null) {
			for (int j = 0; j < labels.length; j++)
				duel (ft_bench[j], c_bench[j], out ft[j], out c[j]);
		}
		print ("\r\033[K");
		int winner = print_round (name, labels, ft, c);
		if (winner == 1)
			me_score++;
		else if (winner == -1)
			opp_score++;
		string score = "score  %s %d ─ %d %s".printf (me, me_score, opp_score, opp);
		print ("  %s\033[90m%s\033[0m\n", pad ("", (BOX_WIDTH - score.char_count ()) / 2), score);
	}

	print_recap (opp_score, me_score);
}
