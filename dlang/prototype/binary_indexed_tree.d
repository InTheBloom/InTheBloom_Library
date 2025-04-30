/// Binary Indexed Tree
/// (型, 二項演算（和）, ゼロ元, 単項演算（逆元）)を指定して実体化する。
/// 二項演算は"a + b"などのstringか(T, T) -> Tのシグネチャで呼び出しできるものならよい。
/// ゼロ元はリテラルでもよいし、stringでもよいし、引数なしで値を返すものでもよい。
/// 単項演算は"-a"などのstringか(T) -> Tのシグネチャで呼び出しできるものならよい。
///
/// 例:
/// Range Sum Query:
/// - BinaryIndexedTree!(int, (int x, int y) => x + y, () => 0, (int x) => -x);
/// - BinaryIndexedTree!(int, "a + b", 0, "-a");
/// - BinaryIndexedTree!(int, "a + b", "0", "-a");
///
/// 提供するメソッド一覧:
/// - this (size_t _N): 要素数_NでBITを作成。
/// - this (R range): InputRange Rから作成。Tへ暗黙変換できる必要がある。
/// - size_t length (): 現在の要素数を返す。
/// - size_t append (T v): 末尾にvを追加。追加後の要素数を返す。
/// - T sum (size_t r): [0, r)の和を返す。逆元が壊れていても動作する。
/// - T sum (size_t l, size_t r): [l, r)の和を返す。
/// - void add (size_t i, T v): i番目にvを足す。
/// - void set (size_t i, T v): i番目をvに変更する。逆元に依存する。

class BinaryIndexedTree (T, alias op_in, alias e_in, alias inv_in) {
    import std.functional: binaryFun, unaryFun;
    import std.range.primitives: isInputRange, hasLength;
    import std.traits: isImplicitlyConvertible, ForeachType;
    import std.exception: enforce;
    import std.range: enumerate;

    // テンプレート引数の変換
    static if (is(typeof(op_in) == string)) {
        alias op = binaryFun!(op_in);
    }
    else {
        alias op = op_in;
    }

    static if (is(typeof(e_in) == T)) {
        alias e = () => e_in;
    }
    else static if (is(typeof(e_in) == string)) {
        alias e = () => mixin(e_in);
    }
    else {
        alias e = e_in;
    }

    static if (is(typeof(inv_in) == string)) {
        alias inv = unaryFun!(inv_in);
    }
    else {
        alias inv = inv_in;
    }

    // 各種操作のチェック
    static assert(__traits(compiles, op(T.init, T.init)));
    static assert(is(typeof(op(T.init, T.init)) == T));

    static assert(__traits(compiles, e()));
    static assert(is(typeof(e()) == T));

    static assert(__traits(compiles, inv(T.init)));
    static assert(is(typeof(inv(T.init)) == T));

    int N;
    T[] data;
    this (size_t _N) {
        enforce(0 <= _N);
        struct ZeroRange {
            size_t rem;
            bool empty () { return rem <= 0; }
            T front () { return e(); }
            void popFront () { rem--; }
        }

        this(ZeroRange(_N));
    }

    this (R) (R range) {
        static assert(isImplicitlyConvertible!(ForeachType!(R), T));

        // 事前に長さが取れないInputRangeの場合はappendを呼ぶようにする
        static if (!hasLength!(R)) {
            data = new T[](1);
            foreach (v; range) {
                append(v);
            }
            return;
        }
        else {
            const size_t len = range.length;
            data = new T[](len + 1);
            foreach (i, v; range.enumerate(1)) {
                data[i] = v;
                N++;
            }

            for (int i = 1; i < N; i++) {
                if (N < i + (-i & i)) {
                    continue;
                }
                data[i + (-i & i)] = op(data[i + (-i & i)], data[i]);
            }
        }
    }

    size_t length () const {
        return N;
    }

    size_t append (T v) {
        // dataの末尾に追加
        N++;
        data ~= v;
        int cur = 1 << 0;
        while ((N & cur) == 0) {
            data[N] = op(data[N], data[N - cur]);
            cur <<= 1;
        }

        return N;
    }

    T sum_1_indexed_upto (size_t r) const {
        // 1-indexed
        // [1, r]の和
        enforce(1 <= r && r <= N);
        T ret = e();
        for (size_t i = r; 0 < i; i -= -i & i) {
            ret = op(ret, data[i]);
        }
        return ret;
    }

    T sum (size_t r) const {
        // 0-indexed
        // [0, r)の和（逆元が壊れていても正しい値を返す）
        enforce(0 <= r && r <= N);
        if (r == 0) {
            return e();
        }
        return sum_1_indexed_upto(r);
    }

    T sum (size_t l, size_t r) const {
        // 0-indexed
        // [l, r)の和
        enforce(0 <= l && l < N);
        enforce(0 <= r && r <= N);
        enforce(l <= r);
        if (l == r) {
            return e();
        }
        if (l == 0) {
            return sum_1_indexed_upto(r);
        }
        return op(sum_1_indexed_upto(r), inv(sum_1_indexed_upto(l)));
    }

    void add (size_t i, T v) {
        // 0-indexed
        // 逆元が正しくないと壊れる
        enforce(0 <= i && i < N);
        i++;
        for (; i <= N; i += -i & i) {
            data[i] = op(data[i], v);
        }
    }

    void set (size_t i, T v) {
        // 0-indexed
        enforce(0 <= i && i < N);
        add(i, inv(sum(i, i + 1)));
        add(i, v);
    }
}
