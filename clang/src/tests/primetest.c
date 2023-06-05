#include <stdio.h>
#include <stdlib.h>
#include <limits.h>
#include "../src/prime_factorization.c"

void test (void) {
	prime_t x = factorization(2623561561, -1);
	printf("2623561561 = ");
	for (int i = 0; x.fact[i] != 0; i++) {
		printf("%lld * ", x.fact[i]);
	}
	printf("\n");
}

int main (void) {
	test();
	return 0;
	for (unsigned long long int i = 1; INT_MAX > i; i++) {
		printf("%llu\n", i);
		prime_t tmp = factorization(i, -1);
		//*
		printf("num = %lli\n", i);
		for (int i = 0; tmp.fact[i] != 0; i++) {
			printf("factor = %llu, power = %i\n", tmp.fact[i], tmp.pow[i]);
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
