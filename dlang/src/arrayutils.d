/// 配列特化二分探索
/// fun: T -> boolが必要。また、一度falseになったら後ろが必ずfalseになるような述語を仮定。
/// fun: (int, T) -> boolにも対応済み
/// 戻り値はスライス2個。
/// それぞれB1, B2としたとき、
/// B1の要素はfun(b1)がtrue
/// B2の要素はfun(b2)がfalse

import std.traits;

T[][2] arrayBSearch (alias fun, T) (T[] A)
if ((__traits(compiles, fun(T.init)) || __traits(compiles, fun(int.init, T.init)))
    && (is(typeof(fun(T.init)) == bool) || is(typeof(fun(int.init, T.init)) == bool))
    ) {
    if (A.length == 0) {
        return [[], []];
    }
    static if (__traits(compiles, fun(int.init, T.init))) {
        bool fi = fun(0, A[0]);
    }
    else {
        bool fi = fun(A[0]);
    }
    if (!fi) {
        return [[], A[]];
    }

    int l = 0, r = cast(int)(A.length);
    while (1 < r - l) {
        int mid = (l + r) / 2;
        static if (__traits(compiles, fun(int.init, T.init))) {
            bool ok = fun(mid, A[mid]);
        }
        else {
            bool ok = fun(A[mid]);
        }

        if (ok) {
            l = mid;
        }
        else {
            r = mid;
        }
    }
    return [A[0 .. r], A[r .. $]];
}

// 多次元配列初期化
void multiDimInit (T, E) (ref T A, E initVal)
if (isArray!(T)) {
    static if (isArray!(ForeachType!(T))) {
        foreach (i; 0 .. A.length) {
            multiDimInit(A[i], initVal);
        }
    }
    else {
        enum c1 = is(E == ForeachType!(T));
        enum c2 = isImplicitlyConvertible!(E, ForeachType!(T));
        static if (!c1 && c2) {
            import std.format;
            pragma(msg, format("[警告] multiDimInit: 型%sの値を型%sの配列へ代入しようとしています。問題無ければ警告は無視してください。", E.stringof, ForeachType!(T).stringof));
        }
        static if (!c2) {
            import std.format;
            pragma(msg, format("[エラー] multiDimInit: 型%sの値を型%sの配列へ代入できません。", E.stringof, ForeachType!(T).stringof));
        }

        foreach (i; 0 .. A.length) {
            A[i] = initVal;
        }
    }
}
