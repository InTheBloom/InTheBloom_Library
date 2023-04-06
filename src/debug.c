#define EPRINT_INT(x) {\
	long long Z = x;\
	fprintf(stderr, #x);\
	fprintf(stderr, " = %lld\n", Z);\
}
#define EPRINT_STR(x) {\
	fprintf(stderr, #x);\
	fprintf(stderr, " = %s\n", x);\
}
#define EPRINT_ARRAY(x, n) do {\
	fprintf(stderr, "[ ");\
	for (int qq = 0; qq < n; qq++) {\
		long long Z = x[qq];\
		fprintf(stderr, "%lld ", Z);\
	}\
	fprintf(stderr, "]\n");\
} while (0)
