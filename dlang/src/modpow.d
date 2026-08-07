long modPow (long a, long x, const long MOD) {
    import std.exception;
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

long modInv (const long x, const long MOD)
    import std.exception;
    import std.format : format;
    enforce(1 <= MOD, format("MOD must satisfy 1 <= MOD. Now MOD =  %s.", MOD));
    enforce(MOD <= int.max, format("MOD must satisfy MOD*MOD <= long.max. Now MOD = %s.", MOD));
    return mod_pow(x, MOD-2, MOD);
}
