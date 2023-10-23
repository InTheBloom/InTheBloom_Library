import std.functional : binaryFun;
import std.traits : ReturnType, isCallable, Parameters;
import std.meta : AliasSeq;

class SegmentTree (T, alias ope, alias e)
if (
           isCallable!(ope)
        && isCallable!(e)
        && is (ReturnType!(ope) == T)
        && is (ReturnType!(e) == T)
        && is (Parameters!(ope) == AliasSeq!(T, T))
        && is (Parameters!(e) == AliasSeq!())
        )
{
}


void main () {
    int ope (int x, int y) {
        return x+y;
    }
    int e () {
        return 0;
    }

    auto seg = new SegmentTree!(int, ope, ()=>0)();
}
