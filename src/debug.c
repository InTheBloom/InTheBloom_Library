#define EPRINT_INT(x) {\
	long long Z = x;\
	fprintf(stderr, "Line %s: %s = %lld\n", __LINE__, #x, Z);\
}
#define EPRINT_STR(x) {\
	fprintf(stderr, "Line %s: %s = %s\n", __LINE__, #x, x);\
}
#define EPRINT_INT_ARRAY(x, n) do {\
	fprintf(stderr, "Line %s: %s = [", __LINE__, #x);\
	for (int qq = 0; qq < n - 1; qq++) {\
		long long Z = x[qq];\
		fprintf(stderr, "%lld, ", Z);\
	}\
	long long Z = x[n - 1];\
	fprintf(stderr, "%lld]\n", Z);\
} while (0)
