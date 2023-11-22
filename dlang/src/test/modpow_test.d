import std;

// verified with ABC156D - Bouquet

void main () {
    int n, a, b; readln.read(n, a, b);
    const int MOD = 10^^9+7;
    long nCk (int n, int k) {
        if (n < k) return 0;
        long res = 1;
        for (int i = 1; i <= k; i++) {
            (res *= n-i+1) %= MOD;
            (res *= modInv(i, MOD)) %= MOD;
        }

        return res;
    }

    long ans = modPow(2, n, MOD);
    (ans += MOD-1) %= MOD;
    (ans += MOD - ((nCk(n, a) + nCk(n, b)) % MOD)) %= MOD;

    writeln(ans);
}

void read(T...)(string S, ref T args) {
    auto buf = S.split;
    foreach (i, ref arg; args) {
        arg = buf[i].to!(typeof(arg));
    }
}

long modInv (long x, const int MOD) {
    import std.exception;
    enforce(1 <= MOD, format("Line : %s, MOD must be greater than 1. Your input = %s", __LINE__, MOD));
    return modPow(x, MOD-2, MOD);
}

long modPow (long a, long x, const long MOD) {
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

T modPow (T, X, Y) (T a, X x, Y MOD)
if (
        __traits(compiles, x&1, x >>= 1) &&
        __traits(compiles, a %= MOD, a += MOD, a %= MOD, a = 1)
    )
{
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
