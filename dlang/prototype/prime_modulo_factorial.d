// check mod_inv
static assert(__traits(compiles, mod_inv(998244353, 1_000_000_007)));

template PrimeModuloFactorial (ulong M)
if ((1 <= M && M < int.max)
    && ((x) {
        for (int i = 2; i < x; i++) {
            if (x < 1L*i*i) break;
            if (x % i == 0) return false;
        }
        return true;
    })(cast(int) M))
{
    import std.conv : to;
    import std.format : format;

    private:
        long[] fact, fact_inv;
        int N = 0;
        long MOD = M;

    public:
        void build (ulong N_) {
            N = N_.to!int;
            fact.length = fact_inv.length = N+1;

            fact[0] = 1;
            for (int i = 1; i <= N; i++) fact[i] = i * fact[i-1] % MOD;
            fact_inv[N] = mod_inv(fact[N], MOD);
            for (int i = N; 0 < i; i--) fact_inv[i-1] = i * fact_inv[i] % MOD;
        }

        long binom (ulong n_, ulong k_)
        in {
            assert((n_ < k_
                    || (n_ <= N && k_ <= N)),
                    format("Out of range of pre-calculation. MAX = %s, n = %s, k = %s.", N, n_, k_),
                    );
        }
        do {
            int n = n_.to!int;
            int k = k_.to!int;

            if (n < k) return 0;
            long res = fact[n] * fact_inv[k] % MOD;
            return res * fact_inv[n-k] % MOD;
        }

        long factorial (ulong x_)
        in {
            assert(x_ <= N,
                    format("Out of range of pre-calculation. MAX = %s, x = %s.", N, x_),
                    );
        }
        do {
            int x = x_.to!int;
            return fact[x];
        }

        long factorial_inv (ulong x_)
        in {
            assert(x_ <= N,
                    format("Out of range of pre-calculation. MAX = %s, x = %s.", N, x_)
                    );
        }
        do {
            int x = x_.to!int;
            return fact_inv[x];
        }
}
