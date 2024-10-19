class BinaryLiftingLCA {
    /*
       ダブリングによるLCA
       this (int N)
       void set_root (int u)
       void add_edge (int u, int v) (無向)
       void build ()
       int lca (int u, int v)
     */

    int N = 0, max_level = 0;
    int[][] g;
    int[][] ancestor;
    int[] d;
    int root = 0;

    int edge_count = 0;
    bool built = false;

    this (int N)
    in {
        assert(0 <= N);
    }
    do {
        this.N = N;
        g = new int[][](N, 0);
        d = new int[](N);
        import core.bitop : bsr;
        max_level = bsr(N) + 1;
    }

    void set_root (int u)
    in {
        assert(!built);
        assert(0 <= u && u < N);
    }
    do {
        root = u;
    }

    void add_edge (int u, int v)
    in {
        assert(!built);
        assert(0 <= u && u < N);
        assert(0 <= v && v < N);
    }
    do {
        edge_count++;
        g[u] ~= v;
        g[v] ~= u;
    }

    bool is_tree () {
        bool res = true;
        if (edge_count != N - 1) res = false;
        auto vis = new bool[](N);
        void dfs (int pos, int par) {
            vis[pos] = true;
            foreach (to; g[pos]) {
                if (to == par) continue;
                if (vis[to]) res = false;

                if (!vis[to]) {
                    dfs(to, pos);
                }
            }
        }
        dfs(0, -1);
        foreach (i; 0..N) if (!vis[i]) res = false;
        return res;
    }

    void build ()
    in {
        assert(!built);
        assert(is_tree());
    }
    do {
        ancestor = new int[][](max_level, N);
        {
            void dfs (int pos, int par) {
                ancestor[0][pos] = par;
                if (par != -1) d[pos] = d[par] + 1;
                foreach (to; g[pos]) {
                    if (to == par) continue;
                    dfs(to, pos);
                }
            }
            dfs(root, -1);
        }

        foreach (j; 0..max_level - 1) {
            foreach (i; 0..N) {
                if (ancestor[j][i] == -1) {
                    ancestor[j + 1][i] = -1;
                    continue;
                }
                ancestor[j + 1][i] = ancestor[j][ancestor[j][i]];
            }
        }

        built = true;
    }

    int lca (int u, int v)
    in {
        assert(built);
        assert(0 <= u && u < N);
        assert(0 <= v && v < N);
    }
    do {
        // 深さを合わせる
        if (d[v] < d[u]) swap(u, v);
        int rem = d[v] - d[u];
        foreach (i; 0..max_level) {
            if (0 < (rem & (1 << i))) v = ancestor[i][v];
        }

        if (u == v) return u;

        foreach_reverse (i; 0..max_level) {
            int au = ancestor[i][u];
            int av = ancestor[i][v];
            if (au == -1 || av == -1) continue;
            if (au == av) continue;

            u = au;
            v = av;
        }
        u = ancestor[0][u];

        return u;
    }

    int depth (int u)
    in {
        assert(0 <= u && u < N);
    }
    do {
        return d[u];
    }
}

