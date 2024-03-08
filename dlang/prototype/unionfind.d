class UnionFind_Array {
    /*
     * VERYFYIED
     *   - uniteとsame : yosupo judge (https://judge.yosupo.jp/problem/unionfind)
     *
     * UNVERYFYIED
     *   - countGroups
     *   - GroupSize
     *   - enumGroups
     */
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

    int root (int x) 
    in {
        assert(0 <= x && x < N);
    }
    do {
        if (parent[x] == x) return x;
        return parent[x] = root(parent[x]);
    }

    bool same (int x, int y)
    in {
        assert(0 <= x && x < N);
        assert(0 <= y && y < N);
    }
    do {
        return root(x) == root(y);
    }

    void unite (int x, int y)
    in {
        assert(0 <= x && x < N);
        assert(0 <= y && y < N);
    }
    do {
        int larger, smaller;
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
        foreach (i; 0..N) if (root(i) == i) res++;
        return res;
    }

    int GroupSize (int x)
    in {
        assert(0 <= x && x < N);
    }
    do {
        return size[root(x)];
    }

    int[][] enumGroups (int x)
    in {
        assert(0 <= x && x < N);
    }
    do {
        int[][] mp = new int[][](N, 0);
        foreach (i; 0..N) {
            mp[root(i)] ~= i;
        }

        int[][] res;
        foreach (m; mp) {
            if (m.length == 0) continue;
            res ~= m;
        }

        return res;
    }

    void reset (int N = this.N)
    in {
        assert(0 <= N, "N must be positive integer.");
    }
    do {
        if (N != this.N) {
            this.N = N;
            parent.length = size.length = N;
        }

        foreach (i; 0..N) {
            parent[i] = i;
            size[i] = 1;
        }
    }
}

auto UnionFind (int N) {
    return new UnionFind_Array(N);
}
