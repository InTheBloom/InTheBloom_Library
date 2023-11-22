import std;

void main () {
    foreach (i, x; enumDiv(1_000_000_000_000)) {
        writeln(i, "th divisor is ", x);
    }

    foreach (x; enumDiv(1_000_000_000_000)) {
        writeln(x);
    }

    writeln(enumDiv(100)[0]);
    writeln(enumDiv(100)[0..5]);
    writeln(enumDiv(100)[0..$]);
}

struct enumDiv {
    import std.algorithm : sort;
    import std.exception : enforce;
    import std.format : format;

    int begin = 0, end;
    long[] div;

    this (long N) {
        enforce(1 <= N, format("N must satisfy 1 <= N. Now N = %s", N));

        for (int x = 1; x <= N; x++) {
            if (N < 1L*x*x) break;
            if (N%x == 0) {
                div ~= x;
                if (1L*x*x != N) div ~= N/x;
            }
        }
        div.sort;
        end = cast(int) div.length;
    }

    long opIndex (size_t i) { return div[i]; }
    long[] opSlice (size_t i, size_t j) { return div[i..j]; }
    size_t opDollar () { return div.length; }
    int opApply (int delegate (ref size_t, ref const long) dg) {
        int result = 0;
        foreach (ref i, ref d; div) {
            result = dg(i, d);
            if (0 < result) break;
        }
        return result;
    }
    int opApply (int delegate (ref const long) dg) {
        int result = 0;
        foreach (ref d; div) {
            result = dg(d);
            if (0 < result) break;
        }
        return result;
    }

    size_t length () const { return div.length; }
    bool empty () const { return begin == end; }

    long front () const { return div[begin]; }
    void popFront() { begin++; }

    long back () const { return div[end - 1]; }
    void popBack () { end--; }
}
