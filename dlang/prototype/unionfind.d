class UnionFind {
    import std.exception;
    import std.algorithm;

    int N;
    int[] par;
    int[] sz;
    int gps;

    this (int N) {
        enforce(0 <= N, "N must be positive integer.");
        this.N = N;
        par = new int[](N);
        sz = new int[](N);
        gps = N;
        foreach (i; 0..N) {
            par[i] = i;
            sz[i] = 1;
        }
    }

    int root (int x) {
        enforce(0 <= x && x < N);
        if (par[x] == x) return x;
        return par[x] = root(par[x]);
    }

    bool same (int x, int y) {
        enforce(0 <= x && x < N);
        enforce(0 <= y && y < N);
        return root(x) == root(y);
    }

    void unite (int x, int y) {
        enforce(0 <= x && x < N);
        enforce(0 <= y && y < N);

        x = root(x);
        y = root(y);

        if (x == y) {
            return;
        }

        if (sz[y] < sz[x]) {
            swap(x, y);
        }

        gps--;
        par[x] = y;
        sz[y] += sz[x];
    }

    int groups () {
        return gps;
    }

    size_t size (int x) {
        enforce(0 <= x && x < N);
        return sz[root(x)];
    }
}

unittest {
    // 生成AIが書いた謎unit test
    // とりあえず通るからええやろ

    import std.random;
    import std.algorithm;
    import std.array;
    import std.format;

    enum TEST_CASES = 10;
    enum MAX_N = 500;
    enum MAX_Q = 50;

    auto rnd = Random(unpredictableSeed);

    foreach (tc; 0 .. TEST_CASES) {
        int N = uniform(1, MAX_N + 1, rnd);
        auto uf = new UnionFind(N);

        auto G = new int[][](N);

        foreach (_; 0 .. MAX_Q) {
            int u = uniform(0, N, rnd);
            int v = uniform(0, N, rnd);

            uf.unite(u, v);

            G[u] ~= v;
            G[v] ~= u;

            auto visited = new bool[](N);
            int groupCount = 0;

            foreach (s; 0 .. N) {
                if (visited[s]) continue;

                groupCount++;

                int[] stack = [s];
                visited[s] = true;

                int cnt = 0;
                while (!stack.empty) {
                    int x = stack.back;
                    stack.popBack;
                    cnt++;

                    foreach (to; G[x]) {
                        if (visited[to]) continue;
                        visited[to] = true;
                        stack ~= to;
                    }
                }

                // この成分に属する全頂点の size を確認
                foreach (x; 0 .. N) {
                    if (uf.same(s, x)) {
                        assert(
                            uf.size(x) == cnt,
                            "size mismatch: tc=%s, N=%s, x=%s, expected=%s, actual=%s"
                                .format(tc, N, x, cnt, uf.size(x))
                        );
                    }
                }
            }

            assert(
                uf.groups() == groupCount,
                "groups mismatch: tc=%s, N=%s, expected=%s, actual=%s"
                    .format(tc, N, groupCount, uf.groups())
            );
        }
    }
}
