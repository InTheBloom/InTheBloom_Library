import std;

void main () {
    foreach (x; enumdiv(1_000_000_000_000)) {
        writeln(x);
    }
    writeln(enumdiv(100).empty);
}

struct enumdiv {
    long[] div;
    this (long N) {
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
    long front () const {
        return div[begin];
    }
    void popBack () {
        end--;
    }
    long back () const {
        return div[end - 1];
    }
}
