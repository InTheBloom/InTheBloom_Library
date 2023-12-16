struct enumDivs {
    import std.algorithm : sort;
    import std.exception : enforce;
    import std.format : format;

    int begin = 1, end;
    long[][] divs;

    this (long N) {
        enforce(1 <= N, format("N must satisfy 1 <= N. Now N = %s", N));
        divs = new long[][](N+1);

        for (int x = 1; x <= N; x++) {
            int j = 1;
            while (1L*x*j <= N) {
                divs[x*j] ~= x;
                j++;
            }
        }
        end = cast(int) divs.length;
    }

    long[] opIndex (size_t i) { enforce(0 < i, "Divisors of 0 is undefined."); return divs[i]; }
    long[][] opSlice (size_t i, size_t j) { enforce(0 < i, "Divisors of 0 is undefined."); return divs[i..j]; }
    size_t opDollar () { return divs.length; }
    int opApply (int delegate (ref size_t, const ref long[]) dg) {
        int result = 0;
        foreach (ref i, ref d; divs[1..$]) {
            result = dg(i, d);
            if (result != 0) break;
        }
        return result;
    }
    int opApply (int delegate (const ref long[]) dg) {
        int result = 0;
        foreach (ref d; divs[1..$]) {
            result = dg(d);
            if (result != 0) break;
        }
        return result;
    }

    size_t length () const { return divs.length-1; }
    bool empty () const { return begin == end; }

    auto front () const { return divs[begin]; }
    void popFront() { begin++; }

    auto back () const { return divs[end - 1]; }
    void popBack () { end--; }
}
