/**
 * TODO
 *   - クラスの各関数の仕様をまとめる
 *   - コンストラクタ関数の仕様をまとめる
 *   - assertで落としたときにstderrにメッセージを表示
 *   - 関数名を変えるかもしれん(uniteとareInSameGroupとの整合性が取れてなさすぎ)
 *
 * VERYFYIED
 *   - uniteとareInSameGroup : yosupo judge (https://judge.yosupo.jp/problem/unionfind)
 *
 * UNVERYFYIED
 *   - countGroups
 *   - GroupSize
 *   - enumerateGroups
 */


/* ------------------------------ */
/*        class definition        */
/* ------------------------------ */

class UnionFind_Dictionary (T) {
    private:
        T[T] parent;
        int[T] size;

    T findRoot (T x) {
        if (x !in parent) {
            addElement(x);
            return x;
        }

        if (parent[x] == x) return x;
        return parent[x] = findRoot(parent[x]);
    }

    bool same (T x, T y) {
        return findRoot(x) == findRoot(y);
    }

    void unite (T x, T y) {
        addElement(x), addElement(y);
        T larger, smaller;
        if (GroupSize(x) <= GroupSize(y)) {
            larger = findRoot(y);
            smaller = findRoot(x);
        } else {
            larger = findRoot(x);
            smaller = findRoot(y);
        }

        if (larger == smaller) return;

        parent[smaller] = larger;
        size[larger] += size[smaller];
    }

    int countGroups () {
        int res = 0;
        foreach (key, val; parent) {
            if (findRoot(key) == key) res++;
        }
        return res;
    }

    bool addElement (T x) {
        if (x in parent) return false;
        parent[x] = x;
        size[x] = 1;
        return true;
    }

    int GroupSize (T x) {
        addElement(x);
        return size[findRoot(x)];
    }

    T[][] enumerateGroups (T x) {
        T[][T] mp;
        foreach (key, val; parent) {
            mp[findRoot(key)] ~= key;
        }

        foreach (val; mp) {
            res ~= val;
        }

        return res;
    }
}

class UnionFind_Array {
    private:
        int N;
        int[] parent;
        int[] size;

    this (int N)
    in {
        assert(0 <= N, "N must be positive integer.");
    }
    do {
        this.N = N;
        parent = new int[](N);
        size = new int[](N);
        foreach (i; 0..N) {
            parent[i] = i;
            size[i] = 1;
        }
    }

    int findRoot (int x) 
    in {
        assert(0 <= x && x < N);
    }
    do {
        if (parent[x] == x) return x;
        return parent[x] = findRoot(parent[x]);
    }

    bool same (int x, int y)
    in {
        assert(0 <= x && x < N);
        assert(0 <= y && y < N);
    }
    do {
        return findRoot(x) == findRoot(y);
    }

    void unite (int x, int y)
    in {
        assert(0 <= x && x < N);
        assert(0 <= y && y < N);
    }
    do {
        int larger, smaller;
        if (GroupSize(x) <= GroupSize(y)) {
            larger = findRoot(y);
            smaller = findRoot(x);
        } else {
            larger = findRoot(x);
            smaller = findRoot(y);
        }

        if (larger == smaller) return;

        parent[smaller] = larger;
        size[larger] += size[smaller];
    }

    int countGroups () {
        int res = 0;
        foreach (i; 0..N) if (findRoot(i) == i) res++;
        return res;
    }

    int GroupSize (int x)
    in {
        assert(0 <= x && x < N);
    }
    do {
        return size[findRoot(x)];
    }

    int[][] enumerateGroups (int x)
    in {
        assert(0 <= x && x < N);
    }
    do {
        int[][] mp = new int[][](N, 0);
        foreach (i; 0..N)
            mp[findRoot(i)] ~= i;
        }

        int[][] res = new int[][](resSize);
        foreach (m; mp) {
            if (m.length == 0) continue;
            res ~= m;
        }

        return res;
    }
}

/* ------------------------------ */
/*          Constructors          */
/* ------------------------------ */

/* Dictionary UF */
auto UnionFind (T) () {
    return new UnionFind_Dictionary!(T)();
}

import std.range.primitives : isInputRange;
auto UnionFind (T, E) (E range) if (isInputRange!(E) || is(T == S[], S) || is(T == S[n], S, size_t n)) {
    auto res = new UnionFind_Dictionary!(T)();
    foreach (elem; range) {
        res.addElement(elem);
    }

    return res;
}

/* Array UF */
auto UnionFind (T) (int N) if (is(T == int)) {
    return new UnionFind_Array(N);
}
