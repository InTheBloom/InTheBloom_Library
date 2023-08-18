long modInv (long x, const int MOD) {
    import std.exception;
    enforce(1 <= MOD, format("Line : %s, MOD must be greater than 1. Your input = %s", __LINE__, MOD));
    return modPow(x, MOD-2, MOD);
}
