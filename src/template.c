/* InTheBloom_Template v1.02 (BETA) Last updated: 2023/4/7 */

/* Originally includes 'in_out.c', 'debug.c' */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define EPRINT_INT(x) {\
	long long Z = x;\
	fprintf(stderr, "Line %d: %s = %lld\n", __LINE__, #x, Z);\
}
#define EPRINT_STR(x) {\
	fprintf(stderr, "Line %d: %s = %s\n", __LINE__, #x, x);\
}
#define EPRINT_INT_ARRAY(x, n) do {\
	fprintf(stderr, "Line %d: %s = [", __LINE__, #x);\
	for (int qq = 0; qq < n - 1; qq++) {\
		long long Z = x[qq];\
		fprintf(stderr, "%lld, ", Z);\
	}\
	long long Z = x[n - 1];\
	fprintf(stderr, "%lld]\n", Z);\
} while (0)

#define NEWLINE fprintf(stderr, "\n")

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

void read_int_array (int *x, int n) {
	for (int i = 0; i < n; i++) {
		scanf("%d", &x[i]);
	}
}

// Defined with macros to support multiple types.

#define print_array_with_space(x, n) do {\
	for (int i = 0; i < n; i++) {\
		long long Z = x[i];\
		printf("%lld ", Z);\
	}\
	printf("\n");\
} while (0)

#define print_array_with_newlines(x, n) do {\
	for (int i = 0; i < n; i++) {\
		long long Z = x[i];\
		printf("%lld\n", Z);\
	}\
} while (0)

#define print_int(x) do {\
	long long Z = x;\
	printf("%lld\n", Z);\
} while (0)

#define print_array_with_space(x, n) do {\
	for (int i = 0; i < n; i++) {\
		long long Z = x[i];\
		printf("%lld ", Z);\
	}\
	printf("\n");\
} while (0)

#define print_array_with_newlines(x, n) do {\
	for (int i = 0; i < n; i++) {\
		long long Z = x[i];\
		printf("%lld\n", Z);\
	}\
} while (0)

#define print_int(x) do {\
	long long Z = x;\
	printf("%lld\n", Z);\
} while (0)

void solve () {
}

int main (void) {

	solve();

	return 0;
}
