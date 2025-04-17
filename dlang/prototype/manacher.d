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

unittest {
    import std.algorithm: equal;
    assert(equal(manacher("aabaa"), [1, 1, 3, 1, 1]), "test1");
    assert(equal(manacher("abcbcba"), [1, 1, 2, 4, 2, 1, 1]), "test2");
    assert(equal(manacher("aaaaa"), [1, 2, 3, 2, 1]), "test3");
    assert(equal(manacher("mississippi"), [1, 1, 1, 1, 4, 1, 1, 1, 1, 1, 1]), "test4");
}
