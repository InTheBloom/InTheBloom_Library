import std.typecons : Tuple, tuple;

class LinearSieve {
    /// methods
    /// - void build (ulong N_)
    /// - Tuple!(long, long)[] prime_factors (ulong N_)
    /// - bool is_prime (ulong N_)
    /// - long[] divisors (ulong N_)

    private:
        static int N = 0;
        static int[] lpf;
        static int[] primes;
        static int[] lpf_ord;
        static int[] lpf_pow;

    import std.conv : to;
    import std.format : format;

    public:
        @disable this () {}

        static void build (ulong N_)
        in {
            assert(2 <= N_ && N_ <= int.max, format("Argument N_ = %s does not meet condition.", N_));
        }
        do {
            // Linear sieve.
            if (N+1 <= lpf.length) return;
            N = N_.to!int;

            primes.length = 0;
            lpf.length = N+1;

            lpf[0] = lpf[1] = 1;

            for (int i = 2; i <= N; i++) {
                if (lpf[i] == 0) {
                    lpf[i] = i;
                    primes ~= i;
                }

                foreach (p; primes) {
                    if (lpf[i] < p) break;
                    if (N < 1L * i * p) break;
                    lpf[i * p] = p;
                }
            }

            // Precomputation of prime factorization.
            lpf_ord.length = lpf_pow.length = N+1;
            lpf_pow[] = 1;

            for (int i = 2; i <= N; i++) {
                int prev = i / lpf[i];

                if (lpf[i] == lpf[prev]) {
                    lpf_ord[i] = lpf_ord[prev] + 1;
                    lpf_pow[i] = lpf_pow[prev] * lpf[i];
                }
                else {
                    lpf_ord[i] = 1;
                    lpf_pow[i] = lpf[i];
                }
            }
        }

        static Tuple!(long, long)[] prime_factors (ulong N_)
        in {
            assert(2 <= N_ && N_ <= N, format("Argument N_ = %s is not out of range. The valid range is [2, %s].", N_, N));
        }
        do {
            int n = N_.to!int;
            Tuple!(long, long)[] res;

            while (1 < n) {
                res ~= tuple(1L*lpf[n], 1L*lpf_ord[n]);
                n /= lpf_pow[n];
            }

            return res;
        }

        static bool is_prime (ulong N_)
        in {
            assert(2 <= N_ && N_ <= N, format("Argument N_ = %s is not out of range. The valid range is [2, %s].", N_, N));
        }
        do {
            int N = N_.to!int;
            return lpf[N] == N;
        }

        static long[] divisors (ulong N_)
        in {
            assert(N_ <= N, format("Argument N_ = %s is not out of range. The valid range is [2, %s].", N_, N));
        }
        do {
            if (N_ == 1) return [1L];

            import std.container : SList;
            import std.algorithm : sort;

            auto fac = prime_factors(N_);

            static SList!(Tuple!(int, long)) Q;
            Q.insertFront(tuple(0, 1L)); // (処理済み階層, 値)

            long[] res;
            while (!Q.empty) {
                auto h = Q.front; Q.removeFront;
                if (h[0] == fac.length) {
                    res ~= h[1];
                    continue;
                }

                auto p = fac[h[0]];
                long prod = 1;
                foreach (i; 0..p[1] + 1) {
                    Q.insertFront(tuple(h[0] + 1, h[1] * prod));
                    prod *= p[0];
                }
            }

            res.sort;
            return res;
        }
}
