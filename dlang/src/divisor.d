long[] divisors (ulong N)
in {
    import std.format : format;
    assert(2 <= N && N <= 10L^^16, format("The argument %s is out of the allowable range. The valid range is [2, 10^16].", N));
}
do {
    import std.algorithm : sort;
    long[] res;
    foreach (i; 1..N + 1) {
        if (N < 1L * i * i) break;
        if (N % i == 0) {
            res ~= i;
            if (1L * i * i < N) res ~= N / i;
        }
    }

    res.sort;
    return res;
}

long[][] range_divisors (ulong N)
in {
    import std.format : format;
    assert(2 <= N && N <= 10^^7, format("The argument %s is out of the allowable range. The valid range is [2, 10^7].", N));
}
do {
    long[][] res = new long[][](cast(int) (N + 1), 0);
    for (int i = 1; i <= N; i++) {
        int j = 1;
        while (i * j <= N) {
            res[i * j] ~= i;
            j++;
        }
    }

    return res;
}
