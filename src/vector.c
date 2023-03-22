/* vector(bundle) */
/* The type 'vector' is another name of 'struct vector *' please be careful */

struct vector {
	int *data;
	size_t size;
	size_t maxsize;
};

typedef struct vector * vector;

vector create_vector (size_t datasize) {

	vector x = malloc(sizeof(struct vector));
	if (x == NULL) { // error handling
		fprintf(stderr, "memory allocation failed in 'create_vector()'.\n");
		exit(EXIT_FAILURE);
	}

	if (datasize == 0) { // 128 areas are automatically reserved when argument equal 0
		x->data = malloc(128 * sizeof(int));
		if (x->data == NULL) { // error handling
			fprintf(stderr, "memory allocation failed in 'create_vector()'.\n");
			exit(EXIT_FAILURE);
		}

		x->size = 0;
		x->maxsize = 128;
		return x;
	}

	size_t pow_of_2 = 1;
	for (; datasize > pow_of_2; pow_of_2 *= 2) {}

	x->data = malloc(pow_of_2 * sizeof(int));
	if (x->data == NULL) { // error handling
		fprintf(stderr, "memory allocation failed in 'create_vector()'.\n");
		exit(EXIT_FAILURE);
	}

	x->size = 0;
	x->maxsize = pow_of_2;
	return x;
}

void destroy_vector (vector x) {
	free(x->data);
	x->data = NULL;
	free(x);
	x = NULL;
}

void shrink_vector (vector x) {
	if (x->size == 0) {
		return;
	}

	size_t pow_of_2 = 1;
	for (; x->size > pow_of_2; pow_of_2 *= 2) {}

	if (128 > pow_of_2) {
		return;
	}

	int *tmp = realloc(x->data, pow_of_2 * sizeof(int));
	if (tmp == NULL) {
		fprintf(stderr, "memory allocation failed in 'shrink_vector()'.\n");
		exit(EXIT_FAILURE);
	}

	x->data = tmp;
	x->maxsize = pow_of_2;
}

void push_back (vector x, int y) {
	if (x->maxsize > x->size) {
		x->data[x->size++] = y;
		return;
	}

	x->maxsize *= 2;
	int *tmp = realloc(x->data, x->maxsize * sizeof(int));
	if (tmp == NULL) {
		fprintf(stderr, "memory allocation failed in 'push_back()'.\n");
		exit(EXIT_FAILURE);
	}

	x->data = tmp;
	x->data[x->size++] = y;
}

void pop_back (vector x) {
	if (x->size == 0) {
		return;
	}

	x->size -= 1;
}
