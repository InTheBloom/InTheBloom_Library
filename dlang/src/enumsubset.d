struct enumSubset_(T) {
    import std.exception;
    import std.format;
    import std.range.primitives : ElementType;
    long elemSize;
    long sup;
    long bit = 0L;
    int[] idx;
    enum bool isNumeric = __traits(isIntegral, T);
    static if (!isNumeric) {
        alias E = ElementType!(T);
        E[] res;
        T arr;
    }

    this (T X) {
        static if (isNumeric) {
            auto errmsg = format("LINE: %s, elemSize must be positive integer: your input is %s", __LINE__, elemSize);
            enforce(0 <= X, errmsg);
            this.elemSize = X;
        } else {
            static assert(__traits(compiles, isRandomAccessRange!(T)) || is(T == E[n], E, size_t n) || is(T == E[], E),
                    "T must be Integral type or RandomAccessRange. Now T = ", T.stringof);
            this.elemSize = X.length;
            arr = X;
            res = new E[](this.elemSize);
        }
        sup = 1L << elemSize;
        idx = new int[](elemSize);
    }

    bool empty() const {
        return sup <= bit;
    }

    void popFront() {
        bit++;
    }
    static if (isNumeric) {
        int[] front() {
            int i = 0;
            for (long mask = 1, index = 0; mask < sup; mask <<= 1, index++) {
                if (0 < (mask&bit)) {
                    idx[i++] = cast(int) index;
                }
            }
            return idx[0..i];
        }
    } else {
        E[] front() {
            int i = 0;
            for (long mask = 1, index = 0; mask < sup; mask <<= 1, index++) {
                if (0 < (mask&bit)) {
                    res[i++] = arr[index];
                }
            }
            return res[0..i];
        }
    }
}

auto enumSubset(T) (T X) {
    return enumSubset_!(T)(X);
}

void main () {
    import std.stdio;
    auto s1 = enumSubset(3);
    auto s2 = enumSubset([1, 2, 3]);
    auto s3 = enumSubset("abc");

    foreach (s; s1) {
        writeln(s);
    }
    foreach (s; s2) {
        writeln(s);
    }
    foreach (s; s3) {
        writeln(s);
    }
}
