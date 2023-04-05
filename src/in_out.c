int read_int (void) {
	int x;
	scanf("%d", &x);
	return x;
}

long long read_long_long (void) {
	long long x;
	scanf("%lld", &x);
	return x;
}

void read_str (char *x) {
	scanf("%s", x);
}

void print_array_with_space (int *x, size_t n) {
	for (int i = 0; i < n; i++) {
		printf("%d ", x[i]);
	}
	printf("\n");
}
