void main () {
    import std.stdio;
    auto A = [0, 1, 2, 3, 4];
    auto ret = arrayBSearch!((int x) => x <= 10)(A);
    writeln(ret[0]);
    writeln(ret[1]);

    auto X = new int[][][](3, 5, 10);
    int[5][10][2] SX;
    multiDimInit(X, 1U);
    multiDimInit(SX, 1LU);
    writeln(X);
    writeln(SX);

}

// 配列特化二分探索
// fun: T -> boolが必要。また、一度falseになったら後ろが必ずfalseになるような述語を仮定。
// 戻り値はスライス2個。
// それぞれB1, B2としたとき、
// B1の要素はfun(b1)がtrue
// B2の要素はfun(b2)がfalse

import std.traits;

T[][2] arrayBSearch (alias fun, T) (T[] A)
if (__traits(compiles, fun(T.init))
    && is(typeof(fun(T.init)) == bool)
    ) {
    if (A.length == 0) {
        return [[], []];
    }
    if (!fun(A[0])) {
        return [[], A[]];
    }

    int l = 0, r = cast(int)(A.length);
    while (1 < r - l) {
        int mid = (l + r) / 2;
        if (fun(A[mid])) {
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
        enum c1 = !is(E == ForeachType!(T));
        enum c2 = !isImplicitlyConvertible!(E, ForeachType!(T));
        static if (!c1 && c2) {
            import std.format;
            pragma(msg, format("[警告] multiDimInit: 型%sの値を型%sの配列へ代入しようとしています。", E.stringof, ForeachType!(T).stringof));
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
