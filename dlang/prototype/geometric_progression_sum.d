long geometric_progression_sum (long a, long r, long n, const long MOD)
in {
    assert(0 <= n);
    assert(1 <= MOD);
    assert(MOD <= int.max);
}
do {
    // 正規化
    a %= MOD;
    r %= MOD;
    if (a < 0) a += MOD;
    if (r < 0) r += MOD;

    // 計算
    long S = a;
    long R = r;
    long R_prod = 1;
    long res = 0;

    foreach (i; 0..64) {
        if (n < (1L<<i)) break;
        if ( 0 < (n & (1L<<i)) ) {
            res += R_prod * S % MOD;
            res %= MOD;

            R_prod *= R;
            R_prod %= MOD;
        }

        S += R * S % MOD;
        S %= MOD;
        R *= R;
        R %= MOD;
    }

    return res;
}
