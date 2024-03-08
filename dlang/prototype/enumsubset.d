struct SubsetIndexes {
    long bit;
    int right;
    long MAX;
    int[] res;
    this (size_t N) {
        MAX = 1<<N;
        res = new int[](N);
        right = 0;
    }

    auto front () const { return res[0..right]; }
    bool empty () const { return bit == MAX; }
    void popFront () {
        bit++;
        int i = 0;
        for (int j = 1, val = 0; j < MAX; j <<= 1, val++) if (0 < (j&bit)) res[i++] = val;
        right = i;
    }
}

struct SubsetItems (T) {
    import std.traits : ForeachType, Unconst;
    alias E = Unconst!(ForeachType!T)[];
    E arr;
    E res;
    int right;
    SubsetIndexes subsets;
    this (T arr) {
        this.arr = arr.dup;
        res = new E(arr.length);
        subsets = enumSubset(arr.length);
    }

    auto front () const { return res[0..right]; }
    bool empty () const { return subsets.empty; }
    void popFront () {
        subsets.popFront;
        int i = 0;
        foreach (s; subsets.front) res[i++] = arr[s];
        right = i;
    }
}

auto enumSubset (T) (T arr)
if (is (T == E[], E) || is (T == E[n], E, size_t n))
{
    return SubsetItems!(T)(arr);
}

auto enumSubset (size_t N)
in {
    import std.format : format;
    import std.exception : enforce;
    enforce(0 <= N && N <= 60, format("N must satisfy 0 <= N <= 60. Now N = %s.", N));
}
do {
    return SubsetIndexes(N);
}
