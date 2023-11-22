struct enumDivs {
    import std.algorithm : sort;
    import std.exception : enforce;
    import std.format : format;

    int begin = 0, end;
    long[] divs;

    this (long N) {
        enforce(1 <= N, format("N must satisfy 1 <= N. Now N = %s", N));
        divs = new long[](N+1);

        for (int x = 1; x <= N; x++) {
            int j = 1;
            while (1L*x*j <= N) {
                divs[x*j] ~= x;
                j++;
            }
        }
        end = cast(int) divs.length;
    }

    long[] opIndex (size_t i) { return divs[i]; }
    long[][] opSlice (size_t i, size_t j) { return divs[i..j]; }
    size_t opDollar () { return divs.length; }

    size_t length () const { return div.length; }
    bool empty () const { return begin == end; }

    long[] front () const { return div[begin]; }
    void popFront() { begin++; }

    long[] back () const { return div[end - 1]; }
    void popBack () { end--; }
}
