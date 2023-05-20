// スライスを受け取って、インプレースで次の順列に並べ替える

import std;

void main () {
    int[] a = [1, 2, 3, 4];
    while (a != [4, 3, 2, 1]) {
        writeln(a);
        next_permutation(a);
    }

    while (a != [1, 2, 3, 4]) {
        writeln(a);
        prev_permutation(a);
    }
    writeln(a);
}

void next_permutation(T) (T arr) {
    if (arr.length < 2) {
        return;
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
        return;
    }

    foreach (idx; i+1..arr.length) {
        if (arr[idx] < arr[i]) {
            j = cast(int)idx - 1;
            break;
        }
    }

    if (j <= i) {
        j = cast(int)arr.length - 1;
    }

    swap(arr[i], arr[j]);
    arr = arr[0..i+1] ~ arr[i+1..$].reverse;
}

void prev_permutation(T) (T arr) {
    if (arr.length < 2) {
        return;
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
        return;
    }

    foreach (idx; i+1..arr.length) {
        if (arr[i] < arr[idx]) {
            j = cast(int)idx - 1;
            break;
        }
    }

    if (j <= i) {
        j = cast(int)arr.length - 1;
    }

    swap(arr[i], arr[j]);
    arr = arr[0..i+1] ~ arr[i+1..$].reverse;
}
