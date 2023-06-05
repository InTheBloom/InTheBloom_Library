#define EPRINT_INT(x) {\
	long long Z = x;\
	fprintf(stderr, "Line %d: %s = %lld\n", __LINE__, #x, Z);\
}
#define EPRINT_STR(x) {\
	fprintf(stderr, "Line %d: %s = %s\n", __LINE__, #x, x);\
}
#define EPRINT_INT_ARRAY(x, n) do {\
	if (n > 0) {\
		fprintf(stderr, "Line %d: %s = [", __LINE__, #x);\
		for (int qq = 0; qq < n - 1; qq++) {\
			long long Z = x[qq];\
			fprintf(stderr, "%lld, ", Z);\
		}\
	long long Z = x[n - 1];\
	fprintf(stderr, "%lld]\n", Z);\
	} else {\
		fprintf(stderr, "[]\n");\
	}\
} while (0)

#define NEWLINE fprintf(stderr, "\n")
