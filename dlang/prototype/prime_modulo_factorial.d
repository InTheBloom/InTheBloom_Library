// check mod_inv
static assert(__traits(compiles, mod_inv(998244353, 1_000_000_007)));

class PrimeModuloFactorial (ulong M)
{
    /// methods:
    /// - void build (ulong N_)
    /// - long binom (ulong n_, ulong k_)
    /// - long factorial (ulong x_)
    /// - long factorial_inv (ulong x_)

    import std.conv : to;
    import std.format : format;

    // varidate
    static assert(1 <= M && M < int.max, format("PrimeModuloFactorial: M = %s is out of range. M must be in range of [1, %s].", M, int.max));

    private static bool internal_is_prime (int x) {
        if (x <= 1) return false;
        foreach (i; 2..x + 1) {
            if (x < 1L * i * i) break;
            if (x % i == 0) return false;
        }
        return true;
    }
    static assert(internal_is_prime(M.to!int), format("PrimeModuloFactorial: M = %s is not prime number.", M));

    private:
        static long[] fact, fact_inv;
        static int N = 0;
        static long MOD = M;

    public:
        @disable this () {}

        static void build (ulong N_)
        in {
            assert(0 <= N_ && N_ <= 10^^8, format("N = %s does not satisfy constraints. N must be in range of [0, 10^8].", N_));
        }
        do {
            if (N_ <= N) { N = N_.to!int; return; }
            N = N_.to!int;
            fact.length = fact_inv.length = N + 1;

            fact[0] = 1;
            for (int i = 1; i <= N; i++) fact[i] = i * fact[i - 1] % MOD;
            fact_inv[N] = mod_inv(fact[N], MOD);
            for (int i = N; 0 < i; i--) fact_inv[i - 1] = i * fact_inv[i] % MOD;
        }

        static long binom (ulong n_, ulong k_)
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
            return res * fact_inv[n - k] % MOD;
        }

        static long factorial (ulong x_)
        in {
            assert(x_ <= N,
                    format("Out of range of pre-calculation. MAX = %s, x = %s.", N, x_),
                    );
        }
        do {
            int x = x_.to!int;
            return fact[x];
        }

        static long factorial_inv (ulong x_)
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
