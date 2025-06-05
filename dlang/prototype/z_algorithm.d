int[] zAlgorithm (T) (const T[] S) {
    const int N = cast(int) S.length;
    auto ret = new int[](N);
    if (N == 0) {
        return ret;
    }
    ret[0] = N;

    int i = 1, j = 1;
    // S[0 .. j - i) = S[i .. j)を保つ。

    while (i < N) {
        if (j < i) {
            j = i;
        }

        // LCPを広げる。
        while (j < N) {
            if (S[j - i] != S[j]) {
                break;
            }
            j++;
        }
        ret[i] = j - i;

        // 計算を再利用する。
        int k = 1;
        while (k <= i && i + k < j && i + k + ret[k] < j) {
            ret[i + k] = ret[k];
            k++;
        }

        i += k;
    }

    return ret;
}

unittest {
    import std.algorithm: equal;
    assert(equal(zAlgorithm("abcbcba"), [7, 0, 0, 0, 0, 0, 1]), "test1");
    assert(equal(zAlgorithm("mississippi"), [11, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]), "test2");
    assert(equal(zAlgorithm("ababacaca"), [9, 0, 3, 0, 1, 0, 1, 0, 1]), "test3");
    assert(equal(zAlgorithm("aaaaa"), [5, 4, 3, 2, 1]), "test4");
    assert(equal(zAlgorithm(""), new int[](0)), "test5");
}
