import std.traits : ReturnType, isCallable, Parameters;
import std.meta : AliasSeq;

class SegmentTree (T, alias ope, alias e)
if (
           isCallable!(ope)
        && isCallable!(e)
        && is (ReturnType!(ope) == T)
        && is (ReturnType!(e) == T)
        && is (Parameters!(ope) == AliasSeq!(T, T))
        && is (Parameters!(e) == AliasSeq!())
        )
{
    /* 内部の配列が1-indexedで2冪のセグメントツリー */
    import std.format;
    T[] X;
    size_t length;

    /* --- Constructors --- */
    this (size_t length_) {
        adjust_array_length(length_);
        for (size_t i = length; i < 2*length; i++) {
            X[i] = e();
        }
        build();
    }

    import std.range.primitives : isInputRange;
    this (R) (R Range)
    if (isInputRange!(R) && is (ElementType!(R) == T))
    {
        adjust_array_length(walkLength(Range));
        size_t i = length;
        foreach (item; Range) {
            X[i] = item;
            i++;
        }
        while (i < 2*length) { X[i] = e(); i++; }
        build();
    }

    /* --- Functions --- */
    private 
        void adjust_array_length (size_t length_) {
            length = 1;
            while (length <= length_) length *= 2;
            X = new T[](2*length);
        }

        void set_with_no_update (size_t idx, T val)
        in {
            assert(idx < length,
                    format("In function \"set_with_no_update\", idx is out of range. (length = %s idx = %s)", length, idx));
        }
        do {
            X[length+idx] = val;
        }

        void build () {
            for (size_t i = length-1; 1 <= i; i--) {
                X[i] = ope(X[2*i], X[2*i+1]);
            }
        }

    public
        override string toString () {
            string res = "";
            int level = 1;
            while ((2^^(level-1)) < X.length) {
                res ~= format("level: %2s | ", level);
                for (size_t i = (2^^(level-1)); i < (2^^level); i++) {
                    res ~= format("%s%s", X[i], (i == (2^^level)-1 ? "\n" : " "));
                }
                level++;
            }
            return res;
        }

        void set (size_t idx, T val)
        in {
            assert(idx < length,
                    format("In function \"set\", idx is out of range. (length = %s idx = %s)", length, idx));
        }
        do {
            idx += length;
            X[idx] = val;
            while (2 <= idx) {
                idx /= 2;
                X[idx] = ope(X[2*idx], X[2*idx+1]);
            }
        }

        T get (size_t idx)
        in {
            assert(idx < length,
                    format("In function \"get\", idx is out of range. (length = %s idx = %s)", length, idx));
        }
        do {
            idx += length;
            return X[idx];
        }

        T prod (size_t l, size_t r)
        in {
            assert(l < length,
                    format("In function \"prod\", l is out of range. (length = %s l = %s)", length, l));
            assert(r <= length,
                    format("In function \"prod\", r is out of range. (length = %s r = %s)", length, r));
            assert(l < r,
                    format("In function \"prod\", l < r must be satisfied. (length = %s l = %s, r = %s)", length, l, r));
        }
        do {
            /* Returns all prod O(1) */
            if (l == 0 && r == length) return X[1];

            /* Closed interval [l, r] */
            r--;
            l += length, r += length;
            T LeftProd, RightProd;
            LeftProd = RightProd = e();

            while (l <= r) {
                if (l % 2 == 1) {
                    LeftProd = ope(LeftProd, X[l]);
                    l++;
                }
                if (r % 2 == 0) {
                    RightProd = ope(X[r], RightProd);
                    r--;
                }

                l /= 2;
                r /= 2;
            }

            return ope(LeftProd, RightProd);
        }
}

import std;
void main () {
    int N, Q; readln.read(N, Q);
    int[] A = readln.split.to!(int[]);

    auto seg = new SegmentTree!(int, (int a, int b) => (a^b), () => 0)(A);

    foreach (_; 0..Q) {
        int T, X, Y; readln.read(T, X, Y);
        if (T == 1) {
            seg.set(X-1, seg.get(X-1)^Y);
        }
        if (T == 2) {
            writeln(seg.prod(X-1, Y));
        }
    }
}

void read(T...)(string S, ref T args) {
    auto buf = S.split;
    foreach (i, ref arg; args) {
        arg = buf[i].to!(typeof(arg));
    }
}
