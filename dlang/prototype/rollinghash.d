template RollingHash () {
    import std.exception;
    immutable long modulo = (1L << 61) - 1;
    const long r;

    shared static this () {
        import std.random;
        r = uniform!"[]"(2, modulo - 2);
    }

    struct Hash {
        long value = 0;
        long rPow = 1;

        this (long _value) {
            enforce(0 <= _value && _value < modulo);
            value = _value;
            rPow = r;
        }
    }

    long modMul (const long a, const long b) {
        enforce(0 <= a && a < modulo);
        enforce(0 <= b && b < modulo);
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

    Hash concat (const Hash lh, const Hash rh) {
        Hash ret = Hash();
        ret.value = rh.value;
        ret.value += modMul(lh.value, rh.rPow);
        if (modulo <= ret.value) {
            ret.value -= modulo;
        }
        ret.rPow = modMul(lh.rPow, rh.rPow);
        return ret;
    }

    import std.traits: isImplicitlyConvertible, ForeachType;
    struct HashedSequence {
        Hash[] acc;

        this (T) (const T seq)
        if (__traits(compiles, (T t) => t[0]) &&
            __traits(compiles, (T t) => t.length) &&
            isImplicitlyConvertible!(ForeachType!(T), long)) {
            import std.algorithm;
            // 全てが範囲内かチェック。
            enforce(seq.map!((x) => 0 <= x && x < modulo).fold!((x, y) => x && y)(true));

            acc = new Hash[](seq.length + 1);
            foreach (i; 0 .. seq.length) {
                acc[i + 1] = concat(acc[i], Hash(seq[i]));
            }
        }

        // 右半開区間連続部分列[i, j)のハッシュを計算。
        Hash get (const size_t i, const size_t j) {
            enforce(0 <= i && i < acc.length);
            enforce(0 <= j && j < acc.length);
            enforce(i <= j);

            const size_t length = j - i;
            auto ret = acc[j];
            ret.value -= modMul(acc[length].rPow, acc[i].value);
            if (ret.value < 0) {
                ret.value += modulo;
            }
            ret.rPow = acc[length].rPow;

            return ret;
        }
    }
}

unittest {
    import std.stdio;
    import std.exception;

    writeln("[INFO] test of RollingHash!().Hash");
    alias rh = RollingHash!();

    // 引数なしで単位元になるか
    {
        auto h = rh.Hash();
        assert(h.value == 0);
        assert(h.rPow == 1);
    }

    // 範囲外の値に対するハッシュの構築
    assertThrown(rh.Hash(-1));
    assertThrown(rh.Hash(rh.modulo));

    // 単一引数のときの挙動
    {
        auto h = rh.Hash(100);
        assert(h.value == 100);
        assert(h.rPow == rh.r);
    }

    writeln("[INFO] passed!");
}

unittest {
    import std.stdio;
    import std.bigint;
    import std.random;
    import std.format;

    writeln("[INFO] test of RollingHash!().modMul()");
    alias rh = RollingHash!();
    assert(rh.modulo == (1L << 61) - 1);

    foreach (t; 0 .. 100) {
        long x = uniform!"[]"(0, rh.modulo - 1);
        long y = uniform!"[]"(0, rh.modulo - 1);

        long vl = rh.modMul(x, y);
        long vr = rh.modMul(y, x);

        BigInt correct = x;
        correct *= y;
        correct %= rh.modulo;

        assert(vl == vr && vl == correct, format("vl: %s, vr: %s, correct: %s", vl, vr, correct));
    }
    writeln("[INFO] passed!");
}

unittest {
    import std.stdio;
    import std.exception;

    writeln("[INFO] test of RollingHash!().HashedSequece");
    alias rh = RollingHash!();

    // 構築
    assertNotThrown(rh.HashedSequence([0, 0, 1, rh.modulo - 1]));
    assertThrown(rh.HashedSequence([0, 0, -1, 2]));
    assertThrown(rh.HashedSequence([0, 0, rh.modulo, 2]));

    // 取得クエリ
    {
        auto h = rh.HashedSequence("hogehoge");
        assertNotThrown(h.get(1, 1));
        assertThrown(h.get(1, 0));

        assertNotThrown(h.get(0, 5));
        assertThrown(h.get(-1, 5));

        assertNotThrown(h.get(3, 8));
        assertThrown(h.get(3, 9));

    }

    // 文字列
    {
        auto h1 = rh.HashedSequence("Hello World!");
        auto h2 = rh.HashedSequence("hello world!");

        // "Hello World!" != "hello world!"
        assert(h1.get(0, 12) != h2.get(0, 12));

        // "" == ""
        assert(h1.get(0, 0) == h2.get(0, 0));

        // ell == ell
        assert(h1.get(1, 3) == h2.get(1, 3));

        // " Wor" != " wor"
        assert(h1.get(5, 9) != h2.get(5, 9));
    }

    // 数列
    {
        auto h1 = rh.HashedSequence([3, 1, 4, 1, 5, 42]);
        auto h2 = rh.HashedSequence([42, 4, 1, 5, 10]);

        // [42] == [42]
        assert(h1.get(5, 6) == h2.get(0, 1));

        // [4, 1, 5] == [4, 1, 5]
        assert(h1.get(2, 5) == h2.get(1, 4));

        // [5, 42] != [42, 4]
        assert(h1.get(4, 6) != h2.get(0, 2));
    }

    writeln("passed!");
}
