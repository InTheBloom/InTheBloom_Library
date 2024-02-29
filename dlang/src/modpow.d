long mod_pow (long a, long x, const long MOD)
in {
    assert(0 <= x, "x must satisfy 0 <= x");
    assert(1 <= MOD, "MOD must satisfy 1 <= MOD");
    assert(MOD <= int.max, "MOD must satisfy MOD*MOD <= long.max");
}
do {
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
