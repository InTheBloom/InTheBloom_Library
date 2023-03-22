#include <stdio.h>
#include <stdlib.h>
#include "../src/vector.c"

int main (void) {

	int n;
	scanf("%i", &n);

	vector x = create_vector(0);

	for (int i = 0; n > i; i++) {
		push_back(x, i + 1);
		printf("size = %zu maxsize = %zu\n", x->size, x->maxsize);
	}

	for (int i = 0; n > i; i++) {
		pop_back(x);
		shrink_vector(x);
		printf("size = %zu maxsize = %zu\n", x->size, x->maxsize);
	}

	destroy_vector(x);

	return 0;
}
