// you can compile by using `dmd permutation_test.d -I=../`
import std.stdio;
import permutation;

void main () {
    int[] a = [1, 1, 2, 2, 3];
    do {
        writeln(a);
    } while (next_permutation(a));

    writeln("");

    do {
        writeln(a);
    } while (prev_permutation(a));
}
