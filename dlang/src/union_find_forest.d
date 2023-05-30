struct UnionFind(T) {
    T[T] parent;
    int[T] size;

    // どの要素が一番上の親かを返す。途中経由した頂点もparentの内容がすべて更新される。
    // privateを外しても問題ないが、同一グループ判定にはis_same_group()を使うべき
    private T root (T x) {
        if (parent[x] != x) {
            parent[x] = root(parent[x]);
        }
        return parent[x];
    }

    // 素集合の数を返す。
    int num_of_group () {
        int ret = 0;
        foreach (key, elem; parent) {
            if (key == elem) {
                ret++;
            }
        }
        return ret;
    }

    // 素集合系に要素を(要素数1の集合として)登録する。
    // これをしないと孤立した頂点は系に存在しないものとして扱われ、num_of_group()が正常に動かない。
    // 他の関数は影響を受けない。
    bool register (T x) {
        if (x !in parent) {
            parent[x] = x;
            size[x] = 1;
        }
        return false;
    }

    // ２つの要素が同一集合に属しているかを判定する。
    bool is_same_group (T x, T y) {
        if (x == y) {
            return true;
        }

        if (x !in parent || y !in parent) {
            return false;
        }

        T parx = root(x), pary = root(y);
        return parx == pary;
    }

    // それぞれの要素が属する集合を併合する。
    bool merge_group (T x, T y) {
        if (x == y) {
            return false;
        }

        if (x !in parent) {
            parent[x] = x;
            size[x] = 1;
        }
        if (y !in parent) {
            parent[y] = y;
            size[y] = 1;
        }

        T parx = root(x), pary = root(y);

        if (size[parx] > size[pary]) {
            size[parx] += size[pary];
            parent[pary] = parx;
        } else {
            size[pary] += size[parx];
            parent[parx] = pary;
        }

        return true;
    }

    // 要素が属する集合の要素数を返す。
    int sizeof_group (T x) {
        if (x !in parent) {
            return 1;
        }
        return size[root(x)];
    }
}
