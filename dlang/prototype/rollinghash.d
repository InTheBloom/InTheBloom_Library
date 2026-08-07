template RollingHash (bool keepRawSequence = false) {
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

        static if (keepRawSequence) {
            long[] raws = [];
        }

        this (long _value) {
            enforce(0 <= _value && _value < modulo);
            value = _value;
            rPow = r;

            static if (keepRawSequence) {
                raws = [value];
            }
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

        static if (keepRawSequence) {
            ret.raws = lh.raws.dup ~ rh.raws.dup;
        }
        return ret;
    }

    import std.traits: isImplicitlyConvertible, ForeachType;
    struct HashedSequence {
        Hash[] acc;
        size_t length;

        static if (keepRawSequence) {
            long[] rawseq;
        }

        this (T) (const T seq)
        if (__traits(compiles, (T t) => t[0]) &&
            __traits(compiles, (T t) => t.length) &&
            isImplicitlyConvertible!(ForeachType!(T), long)) {
            import std.algorithm;
            // 全てが範囲内かチェック。
            enforce(seq.map!((x) => 0 <= x && x < modulo).fold!((x, y) => x && y)(true));

            static if (keepRawSequence) {
                rawseq = new long[](seq.length);
                foreach (i; 0 .. seq.length) {
                    rawseq[i] = seq[i];
                }
            }

            length = seq.length;
            acc = new Hash[](seq.length + 1);
            foreach (i; 0 .. seq.length) {
                acc[i + 1] = concat(acc[i], Hash(seq[i]));
            }
        }

        // 右半開区間連続部分列[i, j)のハッシュを計算。
        Hash get (const size_t i, const size_t j) {
            enforce(i <= j);
            enforce(j <= length);

            const size_t L = j - i;
            auto ret = acc[j];
            ret.value -= modMul(acc[L].rPow, acc[i].value);
            if (ret.value < 0) {
                ret.value += modulo;
            }
            ret.rPow = acc[L].rPow;

            static if (keepRawSequence) {
                ret.raws = rawseq[i .. j].dup;
            }

            return ret;
        }
    }

    struct ReversedHashedSequence {
        Hash[] acc;
        size_t length;

        static if (keepRawSequence) {
            long[] rawseq;
        }

        this (T) (const T seq)
        if (__traits(compiles, (T t) => t[0]) &&
            __traits(compiles, (T t) => t.length) &&
            isImplicitlyConvertible!(ForeachType!(T), long)) {
            import std.algorithm;
            // 全てが範囲内かチェック。
            enforce(seq.map!((x) => 0 <= x && x < modulo).fold!((x, y) => x && y)(true));

            static if (keepRawSequence) {
                rawseq = new long[](seq.length);
                foreach (i; 0 .. seq.length) {
                    rawseq[i] = seq[$ - i - 1];
                }
            }

            length = seq.length;
            acc = new Hash[](seq.length + 1);
            foreach (i; 0 .. seq.length) {
                acc[i + 1] = concat(acc[i], Hash(seq[length - i - 1]));
            }
        }

        // 右半開区間連続部分列[i, j)のハッシュを計算。
        Hash get (const size_t i, const size_t j) {
            enforce(i <= j);
            enforce(j <= length);

            const size_t x = length - j;
            const size_t y = length - i;

            const size_t L = y - x;
            auto ret = acc[y];
            ret.value -= modMul(acc[L].rPow, acc[x].value);
            if (ret.value < 0) {
                ret.value += modulo;
            }
            ret.rPow = acc[L].rPow;

            static if (keepRawSequence) {
                ret.raws = rawseq[x .. y].dup;
            }

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

    writeln("[INFO] test of RollingHash!().HashedSequence and RollingHash!().ReversedHashedSequence");
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

        // i側
        assertNotThrown(h.get(0, 5));
        assertThrown(h.get(-1, 5));
        assertNotThrown(h.get(7, 7));
        assertNotThrown(h.get(8, 8));

        // j側
        assertNotThrown(h.get(3, 8));
        assertThrown(h.get(3, 9));
        assertNotThrown(h.get(0, 0));
        assertThrown(h.get(0, -1));
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

    // 反転
    {
        auto h1 = rh.HashedSequence("abcde");
        auto h2 = rh.ReversedHashedSequence("edcba");

        assert(h1.get(0, 5) == h2.get(0, 5));

        auto h3 = rh.HashedSequence("abczzz");
        auto h4 = rh.ReversedHashedSequence("cbappp");

        assert(h3.get(0, 3) == h4.get(0, 3));
        assert(h3.get(0, 2) == h4.get(1, 3));
        assert(h3.get(0, 4) != h4.get(0, 4));
        assert(h3.get(4, 6) != h4.get(4, 6));
    }

    writeln("[INFO] passed!");
}

unittest {
    import std.stdio;
    import std.exception;
    import std.algorithm;
    import std.array;

    writeln("[INFO] test of keepRawSequence");
    alias rh = RollingHash!(true);

    // Hash単体
    {
        auto h = rh.Hash('A');
        assert(h.raws.map!(v => cast(char)(v)).array == "A");
    }

    // 通常
    auto h1 = rh.HashedSequence("Hello ");
    auto h2 = rh.HashedSequence("World!");

    auto x = h1.get(0, 6);
    auto y = h2.get(0, 6);

    assert(x.raws.map!(v => cast(char)(v)).array == "Hello ");
    assert(y.raws.map!(v => cast(char)(v)).array == "World!");

    // 部分区間・空区間
    assert(h1.get(1, 5).raws.map!(v => cast(char)(v)).array == "ello");
    assert(h1.get(3, 3).raws.length == 0);

    // concat
    {
        auto z = rh.concat(x, y);
        assert(z.raws.map!(v => cast(char)(v)).array == "Hello World!");
    }

    // reversed
    {
        auto h = rh.ReversedHashedSequence("abcdef");

        assert(h.get(0, 6).raws.map!(v => cast(char)(v)).array == "fedcba");
        assert(h.get(1, 4).raws.map!(v => cast(char)(v)).array == "dcb");
        assert(h.get(2, 2).raws.length == 0);
    }

    // reversed + concat
    {
        auto h = rh.ReversedHashedSequence("abcdef");

        auto z = rh.concat(
            h.get(0, 4), // dcba
            h.get(3, 6), // fed
        );

        assert(z.raws.map!(v => cast(char)(v)).array == "dcbafed");
    }

    writeln("[INFO] passed!");
}
