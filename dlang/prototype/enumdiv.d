struct enumDiv {
    import std.algorithm;
    import std.exception;
    import std.format;
    int begin = 0, end;
    long[] div;

    this (long N) {
        auto msg = format("Line : %s, N must be greater than or equal to 0. Your input = %s.", __LINE__, N);
        enforce(0 <= N, msg);

        foreach (x; 1..N+1) {
            if (N < x * x) {
                break;
            }
            if (N % x == 0) {
                div ~= x;
                if (x * x != N) {
                    div ~= N / x;
                }
            }
        }
        div.sort;
        end = cast(int)div.length;
    }

    size_t length () {
        return div.length;
    }

    long opIndex (size_t i) {
        return div[i];
    }

    long[] opSlice (size_t i, size_t j) {
        return div[i..j];
    }

    size_t opDollar () {
        return div.length;
    }

    bool empty () const {
        return begin == end;
    }

    void popFront() {
        begin++;
    }
    long front () const {
        return div[begin];
    }
    void popBack () {
        end--;
    }
    long back () const {
        return div[end - 1];
    }
}
