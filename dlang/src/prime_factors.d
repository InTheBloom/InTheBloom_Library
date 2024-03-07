import std.typecons : Tuple, tuple;

Tuple!(long, long)[] prime_factors (long N)
in {
    import std.format : format;
    assert(2 <= N && N <= 10L^^16, format("The argument %s is out of the allowable range. The valid range is [2, 10^16].", N));
} do {
    Tuple!(long, long)[] res;
    foreach (i; 2..N) {
        if (N < 1L*i*i) break;
        if (N % i != 0) continue;

        int count = 0;
        while (N % i == 0) {
            N /= i;
            count++;
        }

        res ~= tuple(1L*i, 1L*count);
    }

    if (1 < N) res ~= tuple(N, 1L);

    return res;
}

string prime_factors_to_string (Tuple!(long, long)[] x) {
    import std.format : format;
    long v = 1;
    foreach (f; x) {
        long p = f[0], e = f[1];
        v *= p^^e;
    }

    string res = format("%s = ", v);
    foreach (i, f; x) {
        long p = f[0], e = f[1];
        res ~= format("%s^%s", p, e);
        if (i == x.length-1) break;
        res ~= " * ";
    }

    return res;
}
