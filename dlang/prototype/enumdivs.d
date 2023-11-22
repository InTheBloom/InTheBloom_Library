struct enumDivs {
    import std.algorithm;
    import std.exception;
    import std.format;
    long[][] div;

    this (long N) {
        auto msg = format("Line : %s, N must be greater than or equal to 0. Your input = %s.", __LINE__, N);
        enforce(0 <= N, msg);

        div = new long[][](N+1, 0);
        foreach (x; 1..N+1) {
            if (N < x*x) {
                break;
            }

            long y = 1;
            while (x*y <= N) {
                div[x*y] ~= x;
                y++;
            }
        }
    }

    size_t length () {
        return div.length;
    }

    long[] opIndex (size_t i) {
        return div[i];
    }

    long[][] opSlice (size_t i, size_t j) {
        return div[i..j];
    }

    size_t opDollar () {
        return div.length;
    }
}
