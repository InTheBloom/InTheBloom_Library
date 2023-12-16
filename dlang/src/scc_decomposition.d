int[][] SccDecomposition (int[][] graph, int[][] revgraph)
in {
    import std.exception : enforce;
    enforce(graph.length == revgraph.length, "graph.length must be equal to revgraph.length");
}
do {
    /**
     * assume:
     * 1. vertex is 0-indexed and maximum vertex number is less than graph.length
     * 2. if graph has edge (u, v), revgraph has edge (v, u).
     *
     * verified with:
     * - yosupo judge | Stringly Connected Components (https://judge.yosupo.jp/problem/scc) (LDC2/632ms/57.90Mib)
     * - AIZU ONLINE JUDGE | 強連結成分分解 (https://onlinejudge.u-aizu.ac.jp/problems/GRL_3_C)
     **/

    bool[] vis = new bool[](graph.length);
    int[] Q; Q.reserve(graph.length);
    void dfs (int pos) {
        vis[pos] = true;
        foreach (to; graph[pos]) {
            if (vis[to]) continue;
            dfs(to);
        }
        Q ~= pos;
    }

    foreach (i; 0..graph.length) {
        if (!vis[i]) dfs(cast(int) i);
    }

    int[][] scc;
    int idx = 0;
    vis[] = false;
    void revdfs (int pos) {
        vis[pos] = true;
        foreach (to; revgraph[pos]) {
            if (vis[to]) continue;
            revdfs(to);
        }
        scc[idx] ~= pos;
    }

    foreach_reverse (q; Q) {
        if (vis[q]) continue;
        scc ~= new int[](0);
        revdfs(q);
        idx++;
    }

    return scc;
}
