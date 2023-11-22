long modPow (long a, long x, ref const long MOD) {
    import std.exception : enforce;

    enforce(0 <= x, "x must satisfy 0 <= x");
    enforce(1 <= MOD, "MOD must satisfy 1 <= MOD");
    enforce(MOD <= int.max, "MOD must satisfy MOD*MOD <= long.max");

    // normalize
    a %= MOD; a += MOD; a %= MOD;

    long res = 1L;
    long base = a;
    while (0 < x) {
        if (0 < (x&1)) (res *= base) %= MOD;
        (base *= base) %= MOD;
        x >>= 1;
    }

    return res % MOD;
}

T modPow (T, X, Y) (T a, X x, ref const Y MOD) {
    import std.exception: enforce;

    enforce(0 <= x, "x must satisfy 0 <= x");
    enforce(1 <= MOD, "MOD must satisfy 1 <= MOD");

    // normalize
    a %= MOD; a += MOD; a %= MOD;

    T res = 1;
    T base = a;
    while (0 < x) {
        if (0 < (x&1)) (res *= base) %= MOD;
        (base *= base) %= MOD;
        x >>= 1;
    }

    return res % MOD;
}
