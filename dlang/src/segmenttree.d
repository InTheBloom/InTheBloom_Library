/// segment tree

/// example:

/// auto seg = new SegmentTree!(int, (a, b) => a + b, () => 0)(N);

/// seg.set(i, x);
/// seg.update(i, x);
/// seg.get(i);
/// seg.prod(l, r);
/// seg.allProd();

/// seg.layers(); -> [0]が葉

/// seg.minLeft(i, (v) => v < 10); -> nullはseg[i]で条件を満たさない
/// seg.maxRight(i, (v) => v < 10); -> nullはseg[i]で条件を満たさない

class SegmentTree (T, alias op, alias e) {
    import std.format;
    import std.traits;
    import std.exception;
    import std.range;

    static assert(is(Unqual!(T) == T),
            "[ERROR] SegmentTree: T must be an unqualified type.");
    static assert(__traits(compiles, op(T.init, T.init)),
            format("[ERROR] SegmentTree: op(%s, %s) must be callable.", T.stringof, T.stringof));
    static assert(is(typeof(op(T.init, T.init)) == T),
            format("[ERROR] SegmentTree: op(%s, %s) must return %s, but it returns %s.",
                T.stringof, T.stringof, T.stringof, typeof(op(T.init, T.init)).stringof));
    static assert(__traits(compiles, e()),
            "[ERROR] SegmentTree: e() must be callable.");
    static assert(is(typeof(e()) == T),
            format("[ERROR] SegmentTree: e() must return %s, but it returns %s.", T.stringof, typeof(e()).stringof));


    size_t length;
    int leafs;
    T[] node;

    this (size_t N) {
        struct ERange {
            size_t rem;
            size_t length () {
                return rem;
            }
            bool empty () {
                return rem == 0;
            }
            T front () {
                return e();
            }
            void popFront () {
                rem--;
            }
        }

        this(ERange(N));
    }

    this (R) (R range)
    if (isInputRange!(R) && isImplicitlyConvertible!(ForeachType!(R), T) && hasLength!(R))
    {
        length = range.length;
        enforce(1 <= length,
                "[ERROR] SegmentTree: length must be positive.");

        leafs = 1;
        while (leafs < length) {
            leafs *= 2;
        }

        // 全体で2 * leafs - 1ノード必要
        // 1-indexedで使う
        node.length = 2 * leafs;

        foreach (i; 0 .. leafs) {
            T v = e();
            if (!range.empty()) {
                v = range.front();
                range.popFront();
            }
            node[i + leafs] = v;
        }

        foreach_reverse (i; 1 .. leafs) {
            node[i] = op(node[2 * i], node[2 * i + 1]);
        }
    }

    void set (size_t i, T v) {
        enforce(i < length,
                format("[ERROR] SegmentTree.set: index %s is out of range [0, %s).",
                    i, length));

        size_t cur = i + leafs;
        node[cur] = v;
        cur /= 2;
        while (1 <= cur) {
            node[cur] = op(node[2 * cur], node[2 * cur + 1]);
            cur /= 2;
        }
    }

    void update (size_t i, T v) {
        enforce(i < length,
                format("[ERROR] SegmentTree.update: index %s is out of range [0, %s).",
                    i, length));
        size_t cur = i + leafs;
        node[cur] = op(node[cur], v);
        cur /= 2;
        while (1 <= cur) {
            node[cur] = op(node[2 * cur], node[2 * cur + 1]);
            cur /= 2;
        }
    }

    T get (size_t i) {
        enforce(i < length,
                format("[ERROR] SegmentTree.get: index %s is out of range [0, %s).",
                i, length));
        return node[i + leafs];
    }

    T prod (size_t l, size_t r) {
        enforce(l <= r,
            format("[ERROR] SegmentTree.prod: invalid range [%s, %s): l must be <= r.",
                   l, r));
        enforce(r <= length,
            format("[ERROR] SegmentTree.prod: range [%s, %s) is out of range [0, %s).",
                   l, r, length));

        if (l == r) {
            return e();
        }
        if (l == 0 && r == length) {
            return node[1];
        }

        l = l + leafs;
        r = r - 1 + leafs;

        T lp = e(), rp = e();
        while (l <= r) {
            if (l % 2 == 1) {
                lp = op(lp, node[l]);
                l++;
            }
            if (r % 2 == 0) {
                rp = op(node[r], rp);
                r--;
            }

            l /= 2;
            r /= 2;
        }

        return op(lp, rp);
    }

    T allProd () {
        return node[1];
    }

    T[][] layers () {
        auto ret = new T[][](0);
        int w = 1;
        int cur = 1;
        while (true) {
            if (node.length < cur + w) {
                break;
            }
            ret ~= node[cur .. cur + w];
            cur += w;
            w *= 2;
        }

        import std.algorithm;
        ret.reverse;
        return ret;
    }

    import std.typecons;

    Nullable!(int) maxRight (size_t l, bool delegate (T) f) {
        enforce(l < length,
            format("[ERROR] SegmentTree.maxRight: index %s is out of range [0, %s).",
                   l, length));

        Nullable!int ret;
        if (!f(get(l))) {
            return ret;
        }

        if (f(prod(l, length))) {
            ret = cast(int)(length - 1);
            return ret;
        }

        size_t cur = l + leafs;
        T val = e();
        while (true) {
            if (cur % 2 == 1) {
                val = op(val, node[cur]);
                cur++;
            }
            cur /= 2;

            if (!f(op(val, node[cur]))) {
                break;
            }
        }

        while (cur < leafs) {
            if (!f(op(val, node[2 * cur]))) {
                cur = 2 * cur;
            }
            else {
                val = op(val, node[2 * cur]);
                cur = 2 * cur + 1;
            }
        }

        ret = cast(int)(cur - leafs - 1);
        return ret;
    }

    Nullable!(int) minLeft (size_t r, bool delegate (T) f) {
        enforce(r < length,
            format("[ERROR] SegmentTree.minLeft: index %s is out of range [0, %s).",
                   r, length));

        Nullable!int ret;
        if (!f(get(r))) {
            return ret;
        }

        if (f(prod(0, r + 1))) {
            ret = 0;
            return ret;
        }

        size_t cur = r + leafs;
        T val = e();
        while (true) {
            if (cur % 2 == 0) {
                val = op(node[cur], val);
                cur--;
            }
            cur /= 2;

            if (!f(op(node[cur], val))) {
                break;
            }
        }

        while (cur < leafs) {
            if (!f(op(node[2 * cur + 1], val))) {
                cur = 2 * cur + 1;
            }
            else {
                val = op(node[2 * cur + 1], val);
                cur = 2 * cur;
            }
        }

        ret = cast(int)(cur - leafs + 1);
        return ret;
    }
}
