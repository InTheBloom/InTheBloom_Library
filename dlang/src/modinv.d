long modInv (long x, const int MOD) {
    assert(1 <= MOD);
    return modPow(x, MOD-2, MOD);
}
