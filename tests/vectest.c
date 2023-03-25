#include <stdio.h>
#include <stdlib.h>
#include "../src/vector.c"

#define N 500

int main (void) {

	vector x = create_vector(0);

	for (int i = 0; i < N; i++) {
		push_back_vector(x, i + 1);
	}

	printf("x->size = %zu\n", x->size);

	vector y = copy_vector(x);

	range_delete_vector(x, 100, 500); // delete elements of x->data[0, 299], or x->data[0, 300)

	for (int i = 0; x->size > i; i++) {
		printf("%i ", x->data[i]);
	}
	printf("\n");

	printf("x->size = %zu\n", x->size);

	printf("y->size = %zu\n", y->size);

	foreach_vector(y, itery) {
		printf("%i ", itery);
	}
	printf("\n");

	foreach_vector (x, iterx) {
		printf("%i ", iterx);
	}
	printf("\n");

	destroy_vector(x);
	destroy_vector(y);

	return 0;
}
