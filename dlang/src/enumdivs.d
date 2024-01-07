long[][] enumDivs (uint N) {
    long[][] res = new long[][](N+1, 0);
    for (int i = 1; i <= N; i++) {
        int j = 1;
        while (i*j <= N) {
            res[i*j] ~= i;
            j++;
        }
    }

    return res;
}
