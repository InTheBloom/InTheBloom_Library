#include <stdio.h>
#include <stdlib.h>
#include <limits.h>
#include "prime_factorization.c"

int main (void) {
	for (unsigned long long int i = INT_MAX; i >= 2; i--) {
		printf("%llu\n", i);
		prime_t tmp = factorization(i, -1);
		/*
		printf("num = %lli\n", i);
		for (int i = 0; tmp.fact[i] != -1; i++) {
			printf("factor = %i, power = %i\n", tmp.fact[i], tmp.pow[i]);
		}
		puts("");
		// */
		unsigned long long int restoration = 1;
		for (int i = 0; tmp.fact[i] != 0; i++) {
			for (int j = 0; tmp.pow[i] > j; j++) {
				restoration *= tmp.fact[i];
			}
		}
		if (restoration != i) {
			printf("Error occured! num = %llu restoration = %llu\n", i, restoration);
			exit(EXIT_FAILURE);
		}
	}
	printf("Congrats! Library check is Successed!\n");

	return 0;
}
