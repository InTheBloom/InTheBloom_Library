struct enumSubset {
    import std.exception;
    import std.format;
    long elemSize;
    long sup;
    long bit = 0L;
    int[] res;

    this (long elemSize) {
        auto errmsg = format("LINE: %s, elemSize must be positive integer: your input is %s", __LINE__, elemSize);
        enforce(0 <= elemSize, errmsg);
        this.elemSize = elemSize;
        sup = 1L << elemSize;
        res = new int[](elemSize);
    }

    bool empty() const {
        return sup <= bit;
    }

    void popFront() {
        bit++;
    }
    int[] front() {
        int i = 0;
        for (long mask = 1, idx = 0; mask < sup; mask <<= 1, idx++) {
            if (0 < (mask&bit)) {
                res[i++] = cast(int) idx;
            }
        }
        return res[0..i];
    }
}
