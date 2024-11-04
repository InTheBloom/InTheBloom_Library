import std.traits : isIntegral;
import std.int128 : Int128;

T bsearch (alias func, T) (T ok, T ng)
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

    if (ok == ng) return ok;

    T delta;
    if (ok < ng) {
        delta--;
        ng++;
    }
    else {
        delta++;
        ng--;
    }

    while (min(ok, ng) + 1 < max(ok, ng)) {
        T m = midpoint(ok, ng);

        if (func(m + delta)) {
            ok = m;
        }
        else {
            ng = m;
        }
    }

    return ok;
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
