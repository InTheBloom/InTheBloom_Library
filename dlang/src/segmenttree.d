struct SegmentTree (T, T function (T, T) ope, T function () e) {
    /* ---------- variables ---------- */
    T[] X;
    size_t elemSize;

    /* ---------- constructers ---------- */
    // construct by element size
    this (size_t elemSize) {
        extend(elemSize);
        allocate();
        build();
    }

    // construct by input range
    this (E) (E input) {
        import std.range.primitives : hasLength, walkLength, isInputRange;
        static assert(isInputRange!(E));

        if (hasLength!(E)) {
            extend(input.length);
        } else {
            extend(walkLength(input));
        }
        allocate();

        size_t i = 0;
        foreach (ref elem; input) {
            X[this.elemSize+i-1] = elem;
            i++;
        }

        build();
    }

    void extend (size_t sup) {
        this.elemSize = 1;
        while (this.elemSize < sup) {
            this.elemSize *= 2;
        }
    }

    void allocate () {
        X = new T[](2*this.elemSize - 1);
        X[this.elemSize-1..$] = e();
    }

    void build () {
        for (long i = this.elemSize-2; 0 <= i; i--) {
            // calculate from parent node.
            X[i] = ope(X[2*i+1], X[2*i+2]);
        }
    }

    /* ---------- functions ---------- */
    import std.exception : enforce;
    import std.format : format;
    void set (size_t idx, T val) {
        auto errmsg = format("Line : %s, idx must be in the range [0, %s). Your input = %s.", __LINE__, this.elemSize, idx);
        enforce(0 <= idx && idx < this.elemSize, errmsg);

        idx += this.elemSize-1;
        X[idx] = val;

        while (0 < idx) {
            idx = (idx-1)/2;
            X[idx] = ope(X[2*idx+1], X[2*idx+2]);
        }
    }

    T get (size_t idx) {
        auto errmsg = format("Line : %s, idx must be in the range [0, %s). Your input = %s.", __LINE__, this.elemSize, idx);
        enforce(0 <= idx && idx < this.elemSize, errmsg);

        idx += this.elemSize-1;
        return X[idx];
    }

    T prod (size_t l, size_t r) {
        auto errmsg1 = format("Line : %s, l must be in the range [0, %s]. Your input = %s.", __LINE__, this.elemSize, l);
        auto errmsg2 = format("Line : %s, r must be in the range [0, %s]. Your input = %s.", __LINE__, this.elemSize, r);
        auto errmsg3 = format("Line : %s, l must less than or equal to r. Your input = (l = %s, r = %s)", __LINE__, l, r);
        enforce(0 <= l && l <= this.elemSize, errmsg1);
        enforce(0 <= r && r <= this.elemSize, errmsg2);
        enforce(l <= r, errmsg3);

        T res = e();

        // simple cases
        if (l == r) {
            return res;
        }
        if (l == 0 && r == elemSize) {
            return X[0];
        }

        // convert closed interval
        l += this.elemSize-1, r += this.elemSize-2;

        while (true) {
            if (r < l) {
                break;
            }
            if (l == r) {
                res = ope(res, X[l]);
                break;
            }

            if (l % 2 == 0) {
                res = ope(X[l], res);
                l++;
            }
            if (r % 2 == 1) {
                res = ope(res, X[r]);
                r--;
            }
            l = (l-1)/2;
            r = (r-1)/2;
        }

        return res;
    }
}

void main () {
    import std.stdio;
    import std.algorithm;
    int[] x = [1, 3, 5, 7, 8];
    auto seg = SegmentTree!(int, (a, b) => min(a, b), () => int.max)(x);

    writeln(seg.X);
    writeln(seg.prod(2, 5));
}
