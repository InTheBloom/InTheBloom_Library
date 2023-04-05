#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <time.h>
#include "../src/sort.c"

#define N 100

int main (void) {

	srand(time(NULL));

	char random_charactor[N][10];
	char *T[N];

	for (int i = 0; i < N; i++) {
		for (int j = 0; j < 9; j++) {
			random_charactor[i][j] = rand() % 26 + 'a';
		}
		random_charactor[i][9] = '\0';
		T[i] = random_charactor[i];
	}

	heapsort(T, N, sizeof(char *), str_cmp, 1);

	for (int i = 0; i < N; i++) {
		printf("%s\n", T[i]);
	}

	return 0;
}
