struct Ratio {
    long molecule; // 分子
    long denominator = 1; // 分母

    this (long x, long y = 1) {
        this.molecule = x;
        this.denominator = y;
    }
}
