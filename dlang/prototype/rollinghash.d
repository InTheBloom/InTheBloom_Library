template RollingHash () {
    import std.exception;
    immutable long modulo = (1L << 61) - 1;
    const long r;

    shared static this () {
        import std.random;
        r = uniform!"[]"(2, modulo - 2);
    }

    struct Hash {
        long value;
        long rPow;

        this (long _value) {
            enforce(0 <= _value);
            value = _value;
            rPow = r;
        }

        static monoid () {
            auto ret = Hash(0);
            ret.rPow = 0;
            return ret;
        }
    }

    long modMul (long a, long b) {
        enforce(0 <= a && 0 <= b);
        enum MASK31 = (1 << 31) - 1;
        long au = a >> 31;
        long al = a & MASK31;
        long bu = b >> 31;
        long bl = b & MASK31;

        // 2^62 % (2^61 - 2) = 2
        long ret = 2 * au * bu;

        // 本来あった2^31の下駄が外れている。
        // - 下位30bitは上位30bitに変換
        // - 上位31bitは下位31bitに変換
        enum MASK30 = (1 << 30) - 1;

        long m = au * bl + al * bu;

        ret += m >> 30;
        import std.stdio;
        ret += (m & MASK30) << 31;

        ret += al * bl;

        // mod 2^61 - 1を除算なしで計算。
        enum MASK61 = (1L << 61) - 1;
        long lo = ret & MASK61;
        long hi = ret >> 61;

        ret = lo + hi;
        if (modulo <= ret) {
            ret -= modulo;
        }

        return ret;
    }

    Hash concat (const ref Hash lh, const ref Hash rh) {
        Hash ret = Hash.monoid();
        ret.value = 0;
        return ret;
    }
}

unittest {
    import std.bigint;
    import std.random;
    import std.format;
    alias rh = RollingHash!();
    const long MOD = (1L << 61) - 1;

    foreach (t; 0 .. 100) {
        long x = uniform!"[]"(0, MOD - 1);
        long y = uniform!"[]"(0, MOD - 1);

        long vl = rh.modMul(x, y);
        long vr = rh.modMul(y, x);

        BigInt correct = x;
        correct *= y;
        correct %= MOD;

        assert(vl == vr && vl == correct, format("vl: %s, vr: %s, correct: %s", vl, vr, correct));
    }
}
