long modPow (long a, long x, const int MOD) {
    // assertion
    assert(0 <= x);
    assert(1 <= MOD);

    // preparation
    a %= MOD; a += MOD; a %= MOD;

    // simple case
    if (x == 0 || MOD == 1) {
        return 0L;
    }

    if (x == 1) {
        return a;
    }

    // calculate
    long res = 1L;
    long base = a % MOD;
    while (x != 0) {
        if ((x&1) != 0) {
            res *= base;
            res %= MOD;
        }
        base = base*base; base %= MOD;
        x >>= 1;
    }

    return res;
}
