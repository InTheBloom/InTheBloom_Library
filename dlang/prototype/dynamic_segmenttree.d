import std.traits : ReturnType, isCallable, Parameters;
import std.meta : AliasSeq;

class DynamicSegmentTree (T, alias op, alias e) {
    // TODO: assertのメッセージを表示
    static assert(isCallable!(op));
    static assert(isCallable!(e));
    static assert(is (ReturnType!(op) == T));
    static assert(is (ReturnType!(e) == T));
    static assert(is (Parameters!(op) == AliasSeq!(T, T)));
    static assert(is (Parameters!(e) == AliasSeq!()));

    // 内部が1-indexedで動的な完全二分セグメント木
    import std.format : format;
    public:
        this (long N_)
        in { assert(1 <= N_, format("Dynamic SegmentTree: N = %s does not satisfy constraints. N must be in range of [1, %s]", 4 * 10L^^18)); }
        do {
            length = N_;

            // N_以上の2冪に設定
            N = 1;
            while (N < N_) N *= 2;
        }

        void set (long idx, T val)
        in { assert(0 <= idx && idx < length, format("Dynamic SegmentTree: idx = %s does not satisfy constraints. idx must be in range of [0, %s)", idx, length)); }
        do {
            idx++;
            internal_set(root, idx, val, 1, N + 1);
        }

        T get (long idx)
        in { assert(0 <= idx && idx < length, format("Dynamic SegmentTree: idx = %s does not satisfy constraints. idx must be in range of [0, %s)", idx, length)); }
        do {
            idx++;
            return internal_get(root, idx, 1, N + 1);
        }

        T prod (long l, long r)
        in {
            assert(0 <= l && l < length, format("Dynamic SegmentTree: l = %s does not satisfy constraints. l must be in range of [0, %s)", l, length));
            assert(0 <= r && r <= length, format("Dynamic SegmentTree: r = %s does not satisfy constraints. r must be in range of [0, %s]", r, length));
            assert(l <= r, format("Dynamic SegmentTree: l = %s, r = %s does not satisfy constraints. l <= r must be satisfied.", l, r));
        }
        do {
            l++, r++;
            if (l == r) return e();
            return internal_prod(root, l, r, 1, N + 1);
        }

        T all_prod () {
            return internal_prod(root, 1, N + 1, 1, N + 1);
        }

    private:
        struct node {
            long index;
            T value, product;
            node *left = null, right = null;
        }

        void node_update (node *n) {
            n.product = op(
                    op((n.left == null ? e() : n.left.product), n.value),
                    (n.right == null ? e() : n.right.product)
                    );
        }

        node *root = null;
        long N = 0;
        long length = 0;

        // [l, r) : 今見ている部分木が管理する範囲
        node *internal_set (ref node *cur, long idx, T val, long l, long r) {
            if (cur == null) {
                return cur = new node(idx, val, val, null, null);
            }

            if (cur.index == idx) {
                cur.value = val;
                node_update(cur);
                return cur;
            }

            // 既に部分木管理ノードが存在するときの処理
            import std.algorithm : swap;

            long mid = (l + r) / 2;
            if (idx < mid) {
                // 今いる人を押しのける
                if (cur.index < idx) { swap(cur.value, val); swap(cur.index, idx); }
                cur.left = internal_set(cur.left, idx, val, l, mid);
            }
            else {
                if (idx < cur.index) { swap(cur.value, val); swap(cur.index, idx); }
                cur.right = internal_set(cur.right, idx, val, mid, r);
            }

            node_update(cur);
            return cur;
        }

        T internal_get (const node *cur, long idx, long l, long r) {
            if (cur == null) return e();
            if (cur.index == idx) return cur.value;

            long mid = (l + r) / 2;
            if (idx < mid) return internal_get(cur.left, idx, l, mid);
            return internal_get(cur.right, idx, mid, r);
        }

        // [a, b) = 要求区間
        T internal_prod (const node *cur, long a, long b, long l, long r) {
            if (cur == null || b <= l || r <= a) return e();
            if (a <= l && r <= b) return cur.product;

            long mid = (l + r) / 2;
            T res = internal_prod(cur.left, a, b, l, mid);
            if (a <= cur.index && cur.index < b) res = op(res, cur.value);
            res = op(res, internal_prod(cur.right, a, b, mid, r));
            return res;
        }
}
