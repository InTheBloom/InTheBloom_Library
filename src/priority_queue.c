/* you need to include */
#include <stdio.h>
#include <stdlib.h>


struct priority_queue {
    long long *data;
    size_t size;
    size_t maxsize;
    int sort_order;
};

typedef struct priority_queue * priority_queue;

priority_queue create_priority_queue (int order) { // if order > 0 then ascending order. if order < 0 then descending order.
    priority_queue Que = malloc(sizeof(struct priority_queue));
    if (Que == NULL) {
        fprintf(stderr, "memory allocate failed in 'create_priority_queue'\n");
        exit(EXIT_FAILURE);
    }

    Que->data = malloc(32 * sizeof(long long)); // allocating 32 blocks.
    if (Que->data == NULL) {
        fprintf(stderr, "memory allocate failed in 'create_priority_queue'\n");
        exit(EXIT_FAILURE);
    }

    Que->size = 0;
    Que->maxsize = 32;
    Que->sort_order = order;

    return Que;
}

void destroy_priority_queue (priority_queue x) {
    if (x == NULL) {
        return;
    }
    free(x->data);
    x->data = NULL;

    free(x);
    x = NULL;
}

void emplace_priority_queue (priority_queue Que, long long item) {
    if (Que == NULL) {
        fprintf(stderr, "invalid instance (NULL pointer) in 'emplace_priority_queue'\n");
        return;
    }
    if (Que->size < Que->maxsize) {
        Que->data[Que->size++] = item;
        return;
    }

    Que->maxsize *= 2;
    long long *tmp = realloc(Que->data, Que->maxsize);
    if (tmp == NULL) {
        fprintf(stderr, "memory allocate failed in 'emplace_priority_queue'\n");
        exit(EXIT_FAILURE);
    }

    Que->data = tmp;
    Que->data[Que->size++] = item;
}

void build_binaryheap_priority_queue (priority_queue Que, int begin) {
    for (int i = begin; i < Que->size; i++) {
        for (int j = i; 0 < j; j--) {
            int lch = 
        }
    }
}
