struct enumComb_(T) {
    import std.exception;
    import std.format;
    import std.range.primitives : ElementType, isRandomAccessRange;
    long N, K;
    long[] idx;
    bool isEmpty;
    enum bool isNumeric = __traits(isIntegral, T);
    static if (!isNumeric) {
        static assert(__traits(compiles, isRandomAccessRange!(T)) || is(T == E[n], E, size_t n) || is(T == E[], E),
                "T must be Integral type or RandomAccessRange. Now T = ", T.stringof);
        alias E = ElementType!(T);
        E[] res;
        T arr;
    }

    this (T N, long K) {
        static if (isNumeric) {
            auto msgN = format("Line : %s, N must be greater than or equal to 0. your input = %s", __LINE__, N);
            enforce(0 <= N, msgN);
            this.N = N;
        } else {
            this.N = N.length;
            arr = N;
            res = new E[](K);
        }
        auto msgK = format("Line : %s, K must be greater than or equal to 0. your input = %s", __LINE__, K);
        enforce(0 <= K, msgK);

        this.K = K;
        idx = new long[](K);

        init();
    }

    void init () {
        foreach (i; 0..K) {
            idx[i] = i;
        }
        if (N < K) {
            isEmpty = true;
        }
    }

    bool empty() const {
        return isEmpty;
    }

    static if (isNumeric) {
        long[] front() {
            return idx;
        }
    } else {
        E[] front () {
            foreach (i, x; idx) {
                res[i] = arr[x];
            }
            return res;
        }
    }

    void popFront() {
        long index;
        (){
            foreach (i; 0..K) {
                if (idx[$-i-1] < N-i-1) {
                    idx[$-i-1]++;
                    index = K-i-1;
                    return;
                }
            }
            // there is no choice :(
            isEmpty = true;
        }();

        foreach (i; index+1..K) {
            idx[i] = idx[i-1] + 1;
        }
    }
}

auto enumComb(T) (T N, long K) {
    return enumComb_!(T)(N, K);
}

void main () {
    import std.stdio;

    auto e1 = enumComb(4, 2);
    auto e2 = enumComb("abcd", 2);

    foreach (ee; e1) {
        writeln(ee);
    }
    foreach (ee; e2) {
        writeln(ee);
    }
}
