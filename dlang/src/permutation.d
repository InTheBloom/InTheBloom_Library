// スライスを受け取って、インプレースで次の順列に並べ替える

import std;

void main () {
    int[] a = [1, 1, 2, 2, 3];
    do {
        writeln(a);
    } while (next_permutation(a));

    writeln("");

    do {
        writeln(a);
    } while (prev_permutation(a));
}

bool next_permutation(T) (T[] arr) {
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

bool prev_permutation(T) (T[] arr) {
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
