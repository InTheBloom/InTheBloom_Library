import std.format : format;
import std.exception : enforce;

struct CombinationIndexes {
    size_t n, k;
    size_t[] res;
    bool end = false;

    this (size_t n, size_t k) {
        this.n = n, this.k = k;
        if (n < k) end = true;
        if (k == 0) end = true;
        res = new size_t[](k);
        foreach (i; 0..k) res[i] = i;
    }

    bool empty () const { return end; }
    auto front () const { return res; }
    void popFront () {
        bool ok = false;
        if (res[$-1] < n-1) { res[$-1]++; ok = true; return; }
        foreach_reverse (i; 0..k-1) {
            if (res[i]+1 < res[i+1]) {
                res[i]++;
                int diff = 1;
                foreach (j; i+1..k) { res[j] = res[i]+diff; diff++; }
                return;
            }
        }
        end = true;
    }
}

struct CombinationItems (T) {
    import std.traits : ForeachType, Unconst;
    alias E = Unconst!(ForeachType!T)[];
    E arr;
    E res;
    CombinationIndexes comb;
    this (T arr, size_t k) {
        this.arr = arr.dup;
        res = new E(k);
        comb = enumComb(cast(int) arr.length, k);
        int i = 0;
        foreach (c; comb.front) res[i++] = arr[c];
    }

    bool empty () const { return comb.empty; }
    void popFront () {
        comb.popFront;
        int i = 0;
        foreach (c; comb.front) res[i++] = arr[c];
    }
    auto front () const { return res; }
}

auto enumComb (T) (T arr, size_t k)
if (is (T == E[], E) || is (T == E[n], E, size_t n))
in {
    enforce(0 <= k, format("k must satisfy 0 <= n && 0 <= k. Now k = %s.", k));
}
do {
    return CombinationItems!(T)(arr, k);
}

auto enumComb (size_t n, size_t k)
in {
    enforce(0 <= n && 0 <= k, format("n, k must satisfy 0 <= n && 0 <= k. Now n = %s, k = %s.", n, k));
}
do {
    return CombinationIndexes(n, k);
}
