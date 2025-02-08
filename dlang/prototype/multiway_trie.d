class MultiwayTrie (bool ENABLE_SUBTREE_COUNT = false) {
    /* 完全64分木で構築したtrie木
     * 非負整数[0, N)に対してset操作を提供する
     * - this (int N)
     * - int length ()
     * - bool empty ()
     * - bool find (int x)
     * - bool insert (int x)
     * - bool remove (int x)
     * - MultiwayTrieSearchResult successor (int x)
     * - MultiwayTrieSearchResult predecessor (int x)
     * - MultiwayTrieSearchResult min_element ()
     * - MultiwayTrieSearchResult max_element ()
     * - void clear ()
     *
     * ENABLE_SUBTREE_COUNTをオンにすると以下が利用可能
     * - MultiwayTrieSearchResult kth_element ()
     * - int count_at_most (int x)
     */

    import core.bitop: bsr, bsf;
    private alias Int = ulong;
    private enum bitlength = 64;
    private int depth = 2;
    private int padding = 1;
    private Int[] trie;
    static if (ENABLE_SUBTREE_COUNT) {
        private int[] count;
    }
    private int _size;
    private int _N;

    struct MultiwayTrieSearchResult {
        private bool _found = false;
        private uint _value = 0;

        this (int _value) {
            this._found = true;
            this._value = _value;
        }

        @property
        int value () {
            if (!this.found()) {
                throw new Exception("noo");
            }
            return _value;
        }
        @property
        bool found () {
            return _found;
        }
    }

    // よく使う計算たち
    private int fastdiv64 (int x) const {
        assert(0 <= x);
        pragma(inline, true);
        return x >>> 6;
    }
    private int fastmod64 (int x) const {
        assert(0 <= x);
        pragma(inline, true);
        return x & 0b111111;
    }

    private int kth_child (int cur, int k) const {
        assert(0 <= cur);
        assert(0 <= k && k < bitlength);
        pragma(inline, true);
        return cur * bitlength + k + 1;
    }
    private int parent (int cur) const {
        assert(1 <= cur);
        pragma(inline, true);
        return fastdiv64(cur - 1);
    }

    this (int N) {
        // [0, N)を扱う
        // 構築O(N / w)時間、O(N / w)空間
        if (N <= 0) {
            throw new Exception("this");
        }
        _N = N;

        int leaf = bitlength;
        while (leaf < N) {
            depth++;
            padding += leaf;
            leaf *= bitlength;
        }

        int v = padding - leaf / bitlength;
        v += (N + bitlength - 1) / bitlength;
        trie = new Int[](v);
        static if (ENABLE_SUBTREE_COUNT) {
            count = new int[](v);
        }
    }

    @property
    int length () const {
        // O(1)時間
        return _size;
    }
    @property
    bool empty () const {
        return length() == 0;
    }
    bool find (int x) const {
        // O(1)時間
        if (x < 0 || _N <= x) {
            throw new Exception("find");
        }
        int cur = parent(x + padding);
        return 0 < (trie[cur] & (1UL << fastmod64(x)));
    }
    bool insert (int x) {
        // O(logN / logw)時間
        if (x < 0 || _N <= x) {
            throw new Exception("insert");
        }
        if (find(x)) {
            return false;
        }
        _size++;
        int cur = x + padding;
        foreach (_; 0 .. depth - 1) {
            cur = parent(cur);
            static if (ENABLE_SUBTREE_COUNT) {
                count[cur]++;
            }
            trie[cur] |= 1UL << fastmod64(x);
            x = fastdiv64(x);
        }
        return true;
    }
    bool remove (int x) {
        // O(logN / logw)時間
        if (x < 0 || _N <= x) {
            throw new Exception("remove");
        }
        if (!find(x)) {
            return false;
        }
        _size--;

        static if (ENABLE_SUBTREE_COUNT) {
            int v = x + padding;
            while (0 < v) {
                v = parent(v);
                count[v]--;
            }
        }

        int cur = parent(x + padding);
        while (true) {
            trie[cur] ^= 1UL << fastmod64(x);
            if (0 < trie[cur]) break;
            if (cur == 0) break;
            cur = parent(cur);
            x = fastdiv64(x);
        }
        return true;
    }
    auto successor (int x) const {
        // O(logN / logw)時間
        if (x < 0 || _N <= x) {
            throw new Exception("successor");
        }
        if (find(x)) {
            return MultiwayTrieSearchResult(x);
        }
        int cur = x + padding;
        foreach (_; 0 .. depth - 1) {
            cur = parent(cur);
            int msb = trie[cur] == 0 ? 0 : bsr(trie[cur]);
            int target = fastmod64(x);
            if (target < msb) {
                Int mask = ~((1UL << (target + 1)) - 1);
                cur = kth_child(cur, bsf(trie[cur] & mask));
                while (cur < padding) {
                    cur = kth_child(cur, bsf(trie[cur]));
                }
                return MultiwayTrieSearchResult(cur - padding);
            }

            x = fastdiv64(x);
        }
        return MultiwayTrieSearchResult();
    }
    auto predecessor (int x) const {
        // O(logN / logw)時間
        if (x < 0 || _N <= x) {
            throw new Exception("predecessor");
        }
        if (find(x)) {
            return MultiwayTrieSearchResult(x);
        }
        int cur = x + padding;
        foreach (_; 0 .. depth - 1) {
            cur = parent(cur);
            int lsb = trie[cur] == 0 ? bitlength : bsf(trie[cur]);
            int target = fastmod64(x);
            if (lsb < target) {
                Int mask = (1UL << target) - 1;
                cur = kth_child(cur, bsr(trie[cur] & mask));
                while (cur < padding) {
                    cur = kth_child(cur, bsr(trie[cur]));
                }
                return MultiwayTrieSearchResult(cur - padding);
            }

            x = fastdiv64(x);
        }
        return MultiwayTrieSearchResult();
    }
    auto min_element () const {
        // O(logN / logw)時間
        return successor(0);
    }
    auto max_element () const {
        // O(logN / logw)時間
        return predecessor(_N - 1);
    }
    static if (ENABLE_SUBTREE_COUNT) {
        auto kth_element (int k) const {
            // kは1-indexed
            // O(logN)時間
            if (k <= 0) {
                throw new Exception("kth_element");
            }
            if (length() < k) {
                return MultiwayTrieSearchResult();
            }

            int cur = 0;
            int acc = 0;
            foreach (_; 0 .. depth - 2) {
                foreach (i; 0 .. bitlength) {
                    if (k <= acc + count[kth_child(cur, i)]) {
                        cur = kth_child(cur, i);
                        break;
                    }
                    acc += count[kth_child(cur, i)];
                }
            }

            int rem = k - acc;
            foreach (i; 0 .. bitlength) {
                if (0 < (trie[cur] & (1UL << i))) rem--;
                if (rem == 0) {
                    return MultiwayTrieSearchResult(kth_child(cur, i) - padding);
                }
            }
            assert(false, format("supposed to be unreachable."));
        }
        int count_at_most (int x) const {
            // O(logN)時間
            if (x < 0) return 0;
            if (_N <= x) return length();

            int res = 0;
            int cur = parent(x + padding);
            // 葉ノードの数え上げだけはcountを持っていないので別で数える
            int up = fastmod64(x);
            foreach (i; 0 .. up + 1) {
                if (0 < (trie[cur] & (1UL << i))) res++;
            }
            x = fastdiv64(x);

            foreach (_; 0 .. depth - 2) {
                cur = parent(cur);
                up = fastmod64(x);
                foreach (i; 0 .. up) {
                    res += count[kth_child(cur, i)];
                }

                x = fastdiv64(x);
            }
            return res;
        }
    }
    void clear () {
        // O(N)時間
        if (empty()) return;
        _size = 0;
        void dfs (int pos) {
            if (padding < kth_child(pos, 0)) {
                trie[pos] = 0;
                return;
            }
            Int v = trie[pos];
            while (0 < v) {
                int lsb = bsf(v);
                dfs(kth_child(pos, lsb));
                v ^= 1UL << lsb;
            }
            trie[pos] = 0;
        }
        dfs(0);
    }
}

alias MultiwayTrieWithCounter = MultiwayTrie!(true);
alias MultiwayTrieWithoutCounter = MultiwayTrie!(true);
