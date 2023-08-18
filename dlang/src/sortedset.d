import std.container : RedBlackTree;
import std.functional : binaryFun;

struct SortedSet(T, S, alias less = binaryFun!("a.key < b.key")) {
    struct SetNode {
        T key;
        S value;
    }

    auto rbt = new RedBlackTree!(SetNode, less, false)();

    void insert (T key, S value) {
        rbt.insert(SetNode(key, value));
    }

    void removeKey (T key) {
    }

    SetNode front () {
        return rbt.front;
    }

    SetNode back () {
        return rbt.back;
    }
}

import std;
void main () {
    auto set = SortedSet!(int, int, "a.key > b.key")();
    set.insert(10, 5);
    writeln(set.front);
}
