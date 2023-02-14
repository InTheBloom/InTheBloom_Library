#include <stdio.h>
#include <time.h>
#include <stdlib.h>
#define ELEMENT 10000000

void swap (int *a, int *b) {
	int tmp = *a;
	*a = *b;
	*b = tmp;
}

void print_array (int *x, int n) {
	for (int i = 0; n > i; i++) {
		printf("%i ", x[i]);
	}
	printf("\n");
}

void merge (int *a, int l_range, int *b, int r_range, int *tmp) {
	int roop = l_range + r_range;
	int a_count = 0;
	int b_count = 0;
	for (int i = 0; roop > i; i++) {
		if (a[a_count] > b[b_count]) {
			tmp[i] = b[b_count++];
		} else {
			tmp[i] = a[a_count++];
		}

		if (a_count >= l_range) {
			for (i += 1; roop > i; tmp[i++] = b[b_count++]) {}
		} else if (b_count >= r_range) {
			for (i += 1; roop > i; tmp[i++] = a[a_count++]) {}
		}
	}

	for (int i = 0; l_range > i; i++) {
		a[i] = tmp[i];
	}
	for (int i = 0; r_range > i; i++) {
		b[i] = tmp[i + l_range];
	}
}

void mergesort (int *x, int n) {
	int *tmp = malloc(n * sizeof(int));
	int range = 1;
	for (; n > range; range *= 2) {
		for (int i = 0; n > i; ) { // i: 現在位置(配列上のインデックス)
			if (n >= i + 2 * range - 1) {
				merge(&x[i], range, &x[i + range], range, tmp);
				i += 2 * range;
			} else if (n - i > range) {
				merge(&x[i], range, &x[i + range], n - i - range, tmp);
				break;
			} else {
				break;
			}
		}
	}

	if (n == range) {
		range /= 2;
		merge(&x[0], range, &x[range], n - range, tmp);
	}
	free(tmp);
}

int main (void) {
	srand(time(NULL));

	int *x = (int *)malloc(ELEMENT * sizeof(int));
	for (int i = 0; ELEMENT > i; i++) {
		x[i] = rand();
	}

	int start = clock();

	mergesort(x, ELEMENT);

	int end = clock();
	double sort_time = (double)(end - start) / CLOCKS_PER_SEC;

	 /*
	print_array(x, ELEMENT);
	// */

	printf("sorting %i items completed in %fsec\n", ELEMENT, sort_time);
	free(x);
	return 0;
}
