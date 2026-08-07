import std.typecons : Tuple, tuple;

Tuple!(long, int)[] primeFactors (long N) {
    import std.format : format;
    import std.exception;
    enforce(2 <= N && N <= 10L^^16, format("The argument %s is out of the allowable range. The valid range is [2, 10^16].", N));

    Tuple!(long, int)[] res;
    foreach (i; 2..N) {
        if (N < 1L*i*i) break;
        if (N % i != 0) continue;

        int count = 0;
        while (N % i == 0) {
            N /= i;
            count++;
        }

        res ~= tuple(1L*i, count);
    }

    if (1 < N) res ~= tuple(N, 1);

    return res;
}
