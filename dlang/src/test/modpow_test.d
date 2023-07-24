import std;

void main () {
    foreach (i; 0..100_000_000) {
        long a = uniform!"[]"(-long.max , long.max);
        long x = uniform!"[]"(0, long.max);
        int MOD = uniform!"[]"(1, int.max);

        long ans1 = modPow(a, x, MOD);
        long ans2 = recursiveModPow(a, x, MOD);
        if (ans1 != ans2) {
            writeln("wrong answer!");
            writeln("a = ", a);
            writeln("x = ", x);
            writeln("MOD = ", MOD);
            writeln("ans1(not recursive ver) = ", ans1);
            writeln("ans2(recursive ver) = ", ans2);
            return;
        }
    }
    writeln("test passed!");
}

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

long recursiveModPow (long a, long x, const int MOD) {
    // assertion
    assert(1 <= MOD);
    assert(0 <= x);

    // preparation
    a %= MOD; a += MOD; a %= MOD;

    // base case
    if (x == 0) {
        return 1L % MOD;
    }
    if (x == 1) {
        return a;
    }

    // recursive case
    if (x % 2 == 0) {
        long res = recursiveModPow(a, x/2, MOD);
        return res*res % MOD;
    } else {
        return a*recursiveModPow(a, x-1, MOD) % MOD;
    }

    assert(0);
}
