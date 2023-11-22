import std.stdio;

void main () {
    auto a = ["a", "b", "c", "e", "f"];
    do {
        writeln(a);
    } while (NextPermutation(a));

    writeln("");

    do {
        writeln(a);
    } while (PrevPermutation(a));
}

bool NextPermutation (alias less = "a<b", T) (T array)
if (is (T == E[], E) || is (T == E[n], E, size_t n))
{
    import std.algorithm : swap, reverse;
    import std.functional : binaryFun;

    alias is_a_less_than_b = binaryFun!(less);

    int i = -1, j;
    foreach_reverse (idx; 1..array.length) {
        if (is_a_less_than_b(array[idx-1], array[idx])) {
            i = cast(int) (idx-1);
            break;
        }
    }

    // Next permutation doesn't exists.
    if (i == -1) return false;

    foreach_reverse (idx; i+1..array.length) {
        if (is_a_less_than_b(array[i], array[idx])) {
            j = cast(int) idx;
            break;
        }
    }

    swap(array[i], array[j]);
    array[i+1..$].reverse;

    return true;
}

bool PrevPermutation (alias less = "a<b", T) (T array)
if (is (T == E[], E) || is (T == E[n], E, size_t n))
{
    import std.algorithm : swap, reverse;
    import std.functional : binaryFun;

    alias is_a_less_than_b = binaryFun!(less);

    int i = -1, j;
    foreach_reverse (idx; 0..array.length-1) {
        if (is_a_less_than_b(array[idx+1], array[idx])) {
            i = cast(int) idx;
            break;
        }
    }

    // Previous permutation doesn't exists.
    if (i == -1) return false;

    foreach_reverse (idx; i+1..array.length) {
        if (is_a_less_than_b(array[idx], array[i])) {
            j = cast(int)idx;
            break;
        }
    }

    swap(array[i], array[j]);
    array[i+1..$].reverse;

    return true;
}
