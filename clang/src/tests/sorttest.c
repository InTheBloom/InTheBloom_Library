#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include "../src/sort.c"
#define NUM 10000000

int main (void) {
    srand(time(NULL));

    int *x = malloc(NUM * sizeof(int));

    for (int i = 0; NUM > i; i++) {
        x[i] = rand();
    }

    /*
    for (int i = 0; NUM > i; i++) {
        printf("%i ", x[i]);
    }
    printf("\n\n");
    // */

    int start = clock();

    //heapsort(x, NUM, sizeof(int), i_cmp, 1);
    //qsort(x, NUM, sizeof(int), i_cmp);
    mergesort(x, NUM, sizeof(int), i_cmp, 1);

    int end = clock();
    /*
    for (int i = 0; NUM > i; i++) {
        printf("%i ", x[i]);
    }
    printf("\n");
    // */

    double time = (double)(end - start) / CLOCKS_PER_SEC;
    printf("%i items sorted in %f sec\n", NUM, time);
    return 0;
}
