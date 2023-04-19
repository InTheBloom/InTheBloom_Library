int read_int (void) {
	int x;
	scanf("%d", &x);
	return x;
}

double read_double (void) {
	double x;
	scanf("%lf", &x);
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

void read_int_array (int *x, int n) {
	for (int i = 0; i < n; i++) {
		scanf("%d", &x[i]);
	}
}

void read_long_long_array (long long *x, int n) {
	for (int i = 0; i < n; i++) {
		scanf("%lld", &x[i]);
	}
}

// Not to forget to return, these macros are defined

#define YES() do {\
	puts("YES");\
	return;\
} while (0)

#define Yes() do {\
	puts("Yes");\
	return;\
} while (0)

#define yes() do {\
	puts("yes");\
	return;\
} while (0)

#define NO() do {\
	puts("NO");\
	return;\
} while (0)

#define No() do {\
	puts("No");\
	return;\
} while (0)

#define no() do {\
	puts("no");\
	return;\
} while (0)

// Defined with macros to support multiple types.

#define print_int_array_with_space(x, n) do {\
	for (int i = 0; i < n; i++) {\
		long long Z = x[i];\
		printf("%lld ", Z);\
	}\
	printf("\n");\
} while (0)

#define print_int_array_with_newlines(x, n) do {\
	for (int i = 0; i < n; i++) {\
		long long Z = x[i];\
		printf("%lld\n", Z);\
	}\
} while (0)

#define print_int(x) do {\
	long long Z = x;\
	printf("%lld\n", Z);\
} while (0)
