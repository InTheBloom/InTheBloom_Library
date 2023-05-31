struct enumdiv {
    int[] div;
    this (int N) {
        foreach (x; 1..N+1) {
            if (N < x * x) {
                break;
            }
            if (N % x == 0) {
                div ~= x;
                if (x * x != N) {
                    div ~= N / x;
                }
            }
        }
        div.sort;
        end = cast(int)div.length;
    }

    int begin = 0, end;
    invariant () {
        assert(begin <= end);
    }
    bool empty () const {
        return begin == end;
    }

    void popFront() {
        begin++;
    }
    int front () const {
        return div[begin];
    }
    void popBack () {
        end--;
    }
    int back () const {
        return div[end - 1];
    }
}
