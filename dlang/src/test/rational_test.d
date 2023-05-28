// you can compile by using `dmd rational_test.d -I=../`
import std.stdio;
import rational;

void main () {
    Ratio x = Ratio(1, 2);
    writeln(x);
}
