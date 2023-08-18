struct enumComb {
    import std.exception;
    import std.format;
    long N, K;
    long[] idx;
    bool isEmpty;

    this (long N, long K) {
        auto msgN = format("Line : %s, N must be greater than or equal to 0. your input = %s", __LINE__, N);
        auto msgK = format("Line : %s, K must be greater than or equal to 0. your input = %s", __LINE__, K);
        enforce(0 <= N, msgN);
        enforce(0 <= K, msgK);

        this.N = N, this.K = K;
        idx = new long[](K);

        // init
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

    long[] front() {
        return idx;
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
