import std.traits : isIntegral;
import std.int128 : Int128;

class NoTrueRangeException: Exception {
    import std.exception: basicExceptionCtors;
    mixin basicExceptionCtors;
}

class BsearchException: Exception {
    import std.exception: basicExceptionCtors;
    mixin basicExceptionCtors;
}

struct BsearchResult (T) {
    import std.format: format;

    private bool has_value = true;
    private T l, r;
    private T _value;

    this (T _l, T _r) {
        this.l = _l;
        this.r = _r;
        this.has_value = false;
    }
    this (T _l, T _r, T _value) {
        this.l = _l;
        this.r = _r;
        this._value = _value;
    }

    bool empty () {
        return !this.has_value;
    }

    T value () {
        if (this.empty()) {
            throw new NoTrueRangeException(
                    format("No true condition found in the range [%s, %s].", l, r));
        }

        return _value;
    };
}

BsearchResult!T bsearch (alias func, T) (T l, T r)
if ((isIntegral!(T) || is(T == Int128)) &&
        !is(T == byte) &&
        !is(T == ubyte) &&
        !is(T == short) &&
        !is(T == ushort))
{
    import std.traits : isCallable, ReturnType, Parameters;
    import std.meta : AliasSeq;

    static assert(isCallable!(func));
    static assert(is(ReturnType!(func) == bool));
    static assert(is(Parameters!(func) == AliasSeq!(T)));

    import std.algorithm.comparison : min, max;
    T L = l, R = r;

    if (l == r) {
        if (func(l)) return BsearchResult!(T)(L, R, l);
        return BsearchResult!(T)(L, R);
    }

    while (min(l, r) + 1 < max(l, r)) {
        T m = midpoint(l, r);

        if (func(m)) {
            l = m;
        }
        else {
            r = m;
        }
    }

    bool lb = func(l);
    if (!lb) return BsearchResult!(T)(L, R);

    bool rb = func(r);
    if (rb) return BsearchResult!(T)(L, R, r);
    if (!rb) return BsearchResult!(T)(L, R, l);

    throw new BsearchException(format("This code path should never be reached. l: %s, r: %s.", L, R));
}

T midpoint (T) (T a, T b)
if (isIntegral!(T) || is(T == Int128))
{
    static if (is(T == short) || is(T == ushort) || is(T == byte) || is(T == ubyte)) {
        import std.conv : to;
        int x = a, y = b;
        return midpoint(x, y).to!(T);
    }
    else {
        import std.math.algebraic : abs;
        import std.algorithm.comparison : min, max;
        
        int as = (0 <= a) ? 1 : -1, bs = (0 <= b) ? 1 : -1;
        if (as == bs) {
            if (as == 1) {
                return min(a, b) + (max(a, b) - min(a, b)) / 2;
            }
            return max(a, b) + (min(a, b) - max(a, b)) / 2;
        }

        return (a + b) / 2;
    }
}
