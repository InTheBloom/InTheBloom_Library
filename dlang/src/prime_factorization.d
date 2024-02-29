struct PrimeFactorizationResult {
    import std.exception : enforce;
    import std.format : format;

    long N;
    size_t len;
    long[] primes;
    long[] powers;

    this (long N)
    in {
        enforce(2 <= N, format("N must satisfy 2 <= N. Now N = %s.", N));
        enforce(N <= 10L^^16, format("Prime factorization of %s is likely not to finish in time.", N));
    }
    do {
        this.N = N;
        foreach (i; 2..N) {
            if (N < i*i) break;
            if (N%i == 0) {
                primes ~= i;
                int count = 0;
                while (N%i == 0) { count++; N /= i; }
                powers ~= count;
            }
        }
        if (1 < N) {
            primes ~= N;
            powers ~= 1;
        }
        len = primes.length;
    }

    bool isPrime () { return len == 1; }
    long getPower (long p)
    in {
        enforce(2 <= p, format("p must satisfy 2 <= p. Now p = %s", p));
    }
    do {

        foreach (i; 0..len) if (primes[i] == p) return powers[i];
        return 0;
    }

    int opApply (int delegate (long, long) dg) {
        int result = 0;
        foreach (i; 0..primes.length) {
            result = dg(primes[i], powers[i]);
            if (0 < result) break;
        }
        return result;
    }
    int opApply (int delegate (ref size_t, long, long) dg) {
        int result = 0;
        foreach (ref i; 0..primes.length) {
            result = dg(i, primes[i], powers[i]);
            if (0 < result) break;
        }
        return result;
    }

    auto length () const { return len; }

    string toString () {
        string res = format("%s = ", N);
        foreach (i; 0..this.length) {
            if (0 < i) res ~= " * ";
            res ~= format("%s", primes[i]);
            if (1 < powers[i]) res ~= format("^%s", powers[i]);
        }
        return res;
    }
}

auto PrimeFactorization (long N) {
    return PrimeFactorizationResult(N);
}
