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
	for (int qq = 0; qq < n; qq++) {\
		fprintf(stderr, #x);\
		fprintf(stderr, "[%d] = %d\n", qq, x[qq]);\
	} while(0)
