class FunctionalGraph {
    /*
       functional graph関連のアルゴリズム
       構築O(NlogN)
       今のところK回移動したときの結果をO(logN)で取得するアルゴリズムのみある。

       this (int N)
       void add_edge (int from, int to)
       void build ()
       int move_k (int fr, long K)
     */

    int N;
    int[] next;
    int[] roop;
    int[] roop_start;
    int[] roop_size;
    int[] place;

    int[][] doubling;
    int max_table_size = 0;

    bool built = false;

    this (int N) {
        this.N = N;
        roop = new int[](N);
        roop_start = new int[](N);
        roop_start[] = -1;

        roop_size = new int[](N);
        roop_size[] = -1;

        place = new int[](N);
        place[] = -1;

        next = new int[](N);
        next[] = -1;

        import core.bitop : bsr;
        max_table_size = bsr(N) + 1;
        doubling = new int[][](max_table_size, N);
    }

    void add_edge (int from, int to)
    in {
        assert(next[from] == -1);
        assert(0 <= from && from < N);
        assert(0 <= to && to < N);
    }
    do {
        next[from] = to;
    }

    void build ()
    in {
        foreach (i; 0..N) assert(next[i] != -1);
    }
    do {
        // ループを検出: O(N)時間
        auto vis = new bool[](N);
        auto work = new int[](N);
        int latest = 0;

        foreach (i; 0..N) {
            if (vis[i]) continue;
            work.length = 0;

            int cur = i;
            while (!vis[cur]) {
                vis[cur] = true;
                work ~= cur;
                cur = next[cur];
            }

            int start = -1;
            foreach (w; 0..work.length) {
                if (work[w] == cur) {
                    start = w.to!int;
                    break;
                }
            }
            if (start == -1) continue;

            int rs = latest;
            int wl = work.length.to!int;
            foreach (w; work[start..$]) {
                roop[latest] = w;
                roop_start[w] = rs;
                roop_size[w] = wl - start;
                place[w] = latest - rs;
                latest++;
            }
        }

        // ダブリング構築: O(NlogN)時間
        foreach (i; 0..N) {
            doubling[0][i] = next[i];
        }
        foreach (i; 0..max_table_size - 1) {
            foreach (j; 0..N) {
                auto v = doubling[i][j];
                doubling[i + 1][j] = doubling[i][v];
            }
        }

        built = true;
    }

    int move_k (int fr, long K)
    in {
        assert(0 <= K);
        assert(built);
    }
    do {
        // ダブリングしながらループに入った時点でreturn
        foreach_reverse (i; 0..max_table_size) {
            if (roop_start[fr] != -1) {
                break;
            }

            if ((1 << i) <= K) {
                fr = doubling[i][fr];
                K -= (1 << i);
            }
        }
        if (K == 0) {
            return fr;
        }

        int suc = (K + place[fr]) % roop_size[fr];
        return roop[roop_start[fr] + suc];
    }
}

