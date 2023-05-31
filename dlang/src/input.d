void read(T...)(string S, ref T args) {
    auto buf = S.split;
    foreach (i, ref arg; args) {
        arg = buf[i].to!(typeof(arg));
    }
}

void read_array(T)(string S, ref T[] arg) {
    arg = S.split.to!(T[]);
}
