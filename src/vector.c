/* vector(bundle) */
/* The type 'vector' is another name of 'struct vector *' please be careful */

#define FOREACH_vector(x, iter) for (int zz = 0, iter = x->data[zz]; zz < x->size; zz++, iter = x->data[zz])
// foreach_vector macro requires two variables. the first one is `vector`, the other is `int`. Not to cause name collision, roop counter name is `zz`

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

void push_back_vector (vector x, int y) {
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

void pop_back_vector (vector x) {
	if (x->size == 0) {
		return;
	}

	x->size -= 1;
}

vector copy_vector (vector y) { // this function works like x = y. x->size become equal to y->size.

	vector x = create_vector(y->size);

	for (size_t i = 0; y->size > i; i++) {
		push_back_vector(x, y->data[i]);
	}

	return x;
}

void delete_vector (vector x, size_t index) {
	if (index + 1 > x->size) {
		fprintf(stderr, "out of index in 'delete_vector'.\n");
		return;
	}

	for (size_t i = 0; index + i + 1 != x->size; i++) {
		x->data[index + i] = x->data[index + i + 1];
	}

	x->size -= 1;
}

void range_delete_vector (vector x, size_t begin, size_t end) { // this function delete elements of x in range [begin, end).
	if (begin > end) {
		fprintf(stderr, "invalid range in 'range_delete_vector'.\n");
		return;
	}

	if (end > x->size) {
		fprintf(stderr, "out of index in 'range_delete_vector'.\n");
		return;
	}

	for (size_t i = 0; end + i != x->size; i++) {
		x->data[begin + i] = x->data[end + i];
	}

	x->size -= end - begin;
}
