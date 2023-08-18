bool nextPermutation(T) (T[] arr) {
    import std.algorithm;
    static assert(!isRandomAccessRange(T));

    if (arr.length < 2) {
        return false;
    }

    int i = -1, j;
    foreach_reverse (idx; 1..arr.length) {
        if (arr[idx - 1] < arr[idx]) {
            i = cast(int)idx - 1;
            break;
        }
    }

    // 存在しない
    if (i == -1) {
        return false;
    }

    foreach_reverse (idx; i+1..arr.length) {
        if (arr[i] < arr[idx]) {
            j = cast(int)idx;
            break;
        }
    }

    swap(arr[i], arr[j]);
    arr = arr[0..i+1] ~ arr[i+1..$].reverse;
    return true;
}

bool prevPermutation(T) (T arr) {
    import std.algorithm;
    static assert(!isRandomAccessRange(T));

    if (arr.length < 2) {
        return false;
    }

    int i = -1, j;
    foreach_reverse (idx; 1..arr.length) {
        if (arr[idx] < arr[idx - 1]) {
            i = cast(int)idx - 1;
            break;
        }
    }

    // 存在しない
    if (i == -1) {
        return false;
    }

    foreach_reverse (idx; i+1..arr.length) {
        if (arr[idx] < arr[i]) {
            j = cast(int)idx;
            break;
        }
    }

    swap(arr[i], arr[j]);
    arr = arr[0..i+1] ~ arr[i+1..$].reverse;
    return true;
}
