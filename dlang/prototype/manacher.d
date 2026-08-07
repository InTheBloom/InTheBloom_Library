int[] manacher (T) (const T[] S) {
    import std.conv: to;

    const int N = S.length.to!int;
    auto R = new int[](N);

    int i = 0, j = 0;
    while (i < N) {
        // 回文を広げる
        while (0 <= i - j && i + j < N) {
            if (S[i - j] != S[i + j]) break;
            j++;
        }
        R[i] = j;

        // 広がった右側領域を確定した左側領域を利用して確定させる
        int k = 1;
        while (0 <= i - k && i + k < N) {
            if (j - k <= R[i - k]) break;
            R[i + k] = R[i - k];
            k++;
        }

        i += k;
        j -= k;
    }

    return R;
}

struct SubstringPalindromeChecker {
    const int[] ma;
    const size_t length;
    this (T) (const T[] A)
    if (is(T == char) || is(T == int) || is(T == long)) {
        bool[T] mp;
        foreach (a; A) {
            mp[a] = true;
        }
        enforce(!is(T == char) || mp.length < 256, "Separator not found.");

        T pad = T.min;
        while (pad in mp) {
            pad++;
        }

        length = A.length;
        auto seq = new T[](0);
        seq ~= pad;
        foreach (i; 0 .. A.length) {
            seq ~= A[i];
            seq ~= pad;
        }

        ma = manacher(seq);
    }

    import std.exception;
    bool check (size_t l, size_t r) {
        enforce(l <= r);
        enforce(r <= length);

        size_t mid = l + r;
        return 2 * r < ma[mid] + mid + 1;
    }
}

unittest {
    import std.algorithm: equal;

    assert(equal(manacher(""), new int[](0)));
    assert(equal(manacher("aabaa"), [1, 1, 3, 1, 1]));
    assert(equal(manacher("abcbcba"), [1, 1, 2, 4, 2, 1, 1]));
    assert(equal(manacher("aaaaa"), [1, 2, 3, 2, 1]));
    assert(equal(manacher("mississippi"), [1, 1, 1, 1, 4, 1, 1, 1, 1, 1, 1]));

    assert(equal(manacher(new int[](0)), new int[](0)));
    assert(equal(manacher([1, 2, 1]), [1, 2, 1]));
    assert(equal(manacher([1, 2, 3, 2, 1]), [1, 1, 3, 1, 1]));
    assert(equal(manacher([1, 1, 1, 1, 1]), [1, 2, 3, 2, 1]));
    assert(equal(manacher([1, 2, 1, 3, 1, 2, 1]), [1, 2, 1, 4, 1, 2, 1]));
}

unittest {
    {
        auto ch = SubstringPalindromeChecker("abcba__abbe");

        assert(ch.check(0, 5));
        assert(!ch.check(0, 2));
        assert(!ch.check(7, 11));
        assert(ch.check(8, 10));
    }
    {
        auto ch = SubstringPalindromeChecker(
            [1, 2, 3, 2, 1, 10, 20, 20, 30]
        );

        assert(ch.check(0, 5));   // [1, 2, 3, 2, 1]
        assert(!ch.check(0, 4));  // [1, 2, 3, 2]
        assert(ch.check(1, 4));   // [2, 3, 2]

        assert(ch.check(6, 8));   // [20, 20]
        assert(!ch.check(5, 9));  // [10, 20, 20, 30]

        // 長さ0, 1も確認
        assert(ch.check(3, 3));   // []
        assert(ch.check(5, 6));   // [10]
    }
}

unittest {
    import std.exception;
    import std.algorithm;
    import std.range;
    // separator探索アルゴのチェック
    {
        auto ch = SubstringPalindromeChecker([int.min, 1, int.min]);
        assert(ch.check(0, 3));
        assert(!ch.check(0, 2));
    }
    {
        auto ch = SubstringPalindromeChecker([long.min, 10L, long.min]);
        assert(ch.check(0, 3));
    }
    {
        auto ch = SubstringPalindromeChecker(['\0', 'a', '\0']);
        assert(ch.check(0, 3));
    }
    assert(!__traits(compiles, SubstringPalindromeChecker([0UL, 1UL, 2UL])));
    assertThrown(SubstringPalindromeChecker(iota(256).map!(v => cast(char)(v)).array));
    assertNotThrown(SubstringPalindromeChecker(iota(255).map!(v => cast(char)(v)).array));
}
