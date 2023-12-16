class UnionFind_Dictionary (T) {
    private:
        T[T] parent;
        int[T] size;

    T root (T x) {
        if (x !in parent) {
            addElement(x);
            return x;
        }

        if (parent[x] == x) return x;
        return parent[x] = root(parent[x]);
    }

    bool same (T x, T y) {
        return root(x) == root(y);
    }

    void unite (T x, T y) {
        addElement(x), addElement(y);
        T larger, smaller;
        if (GroupSize(x) <= GroupSize(y)) {
            larger = root(y);
            smaller = root(x);
        } else {
            larger = root(x);
            smaller = root(y);
        }

        if (larger == smaller) return;

        parent[smaller] = larger;
        size[larger] += size[smaller];
    }

    int countGroups () {
        int res = 0;
        foreach (key, val; parent) {
            if (root(key) == key) res++;
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
        return size[root(x)];
    }

    T[][] enumGroups (T x) {
        T[][T] mp;
        foreach (key, val; parent) {
            mp[root(key)] ~= key;
        }

        foreach (val; mp) {
            res ~= val;
        }

        return res;
    }

    void reset () {
        parent.clear;
        size.clear;
    }
}

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
