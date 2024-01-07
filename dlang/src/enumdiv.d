long[] enumDiv (ulong N) {
    import std.algorithm : sort;
    long[] res;
    for (int i = 1; i <= N; i++) {
        if (N < 1L*i*i) break;
        if (N % i == 0) {
            res ~= i;
            if (1L*i*i < N) res ~= N/i;
        }
    }

    res.sort;
    return res;
}
