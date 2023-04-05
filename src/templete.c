/* InTheBloom_Templete v1.00 (BETA) */

/* Originally includes 'in_out.c', 'debug.c' */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

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

void solve () {
}

int main (void) {

	return 0;
}
