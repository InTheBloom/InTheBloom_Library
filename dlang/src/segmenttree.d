struct SegmentTree (T, T function (T, T) ope, T function () e) {
    /* ---------- variables ---------- */
    T[] X;
    size_t elemSize;
    size_t arrSize;

    /* ---------- constructers ---------- */
    // construct by element size
    this (size_t elemSize) {
        this.elemSize = elemSize;
        arrSize = extend(elemSize);
        allocate();
        build();
    }

    // construct by input range
    this (E) (E input) {
        import std.range.primitives : hasLength, walkLength, isInputRange, ElementType;
        static assert(isInputRange!(E));
        static assert(is(ElementType!(E) == T), format("\nThe element type of input range that builds the segment tree must be equal to T or upcastable.\nExpected : %s\nRecieved : %s", T.stringof, ElementType!(E).stringof));

        if (hasLength!(E)) {
            this.elemSize = input.length;
        } else {
            this.elemSize = walkLength(input);
        }
        this.arrSize = extend(this.elemSize);
        allocate();

        size_t i = 0;
        foreach (elem; input) {
            X[this.arrSize+i-1] = elem;
            i++;
        }

        build();
    }

    size_t extend (size_t sup) {
        size_t res = 1;
        while (res < sup) {
            res *= 2;
        }
        return res;
    }

    void allocate () {
        X = new T[](2*this.arrSize - 1);
        X[this.arrSize-1..$] = e();
    }

    void build () {
        for (long i = this.arrSize-2; 0 <= i; i--) {
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

        idx += this.arrSize-1;
        X[idx] = val;

        while (0 < idx) {
            idx = (idx-1)/2;
            X[idx] = ope(X[2*idx+1], X[2*idx+2]);
        }
    }

    T get (size_t idx) {
        auto errmsg = format("Line : %s, idx must be in the range [0, %s). Your input = %s.", __LINE__, this.elemSize, idx);
        enforce(0 <= idx && idx < this.elemSize, errmsg);

        idx += this.arrSize-1;
        return X[idx];
    }

    T prod (size_t l, size_t r) {
        auto errmsg1 = format("Line : %s, l must be in the range [0, %s]. Your input = %s.", __LINE__, this.elemSize, l);
        auto errmsg2 = format("Line : %s, r must be in the range [0, %s]. Your input = %s.", __LINE__, this.elemSize, r);
        auto errmsg3 = format("Line : %s, l must less than or equal to r. Your input = (l = %s, r = %s)", __LINE__, l, r);
        enforce(0 <= l && l <= this.elemSize, errmsg1);
        enforce(0 <= r && r <= this.elemSize, errmsg2);
        enforce(l <= r, errmsg3);

        // simple cases
        if (l == r) {
            return e();
        }
        if (l == 0 && r == elemSize) {
            return X[0];
        }
        if (l+1 == r) {
            return X[l];
        }

        // convert closed interval
        l += this.arrSize-1, r += this.arrSize-2;

        T leftProduct = e(), rightProduct = e();

        while (true) {
            if (r < l) {
                break;
            }

            if (l % 2 == 0) {
                leftProduct = ope(X[l], leftProduct);
                l++;
            }
            if (r % 2 == 1) {
                rightProduct = ope(rightProduct, X[r]);
                r--;
            }
            l = (l-1)/2;
            r = (r-1)/2;
        }

        return ope(leftProduct, rightProduct);
    }
}
