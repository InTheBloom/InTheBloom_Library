/* you need to include */
#include <stdio.h>
#include <stdlib.h>


struct priority_queue {
    long long *data;
    size_t size;
    size_t maxsize;
};

typedef struct priority_queue * priority_queue;

priority_queue create_priority_queue (void) {
    priority_queue Que = malloc(sizeof(struct priority_queue));
    if (Que == NULL) {
        fprintf(stderr, "memory allocate failed in 'create_priority_queue'\n");
        exit(EXIT_FAILURE);
    }

    Que->size = 0;
    Que->maxsize = 0;
}

void emplace_priority_queue (priority_queue Que, long long item) {
    if (Que->size < Que->maxsize) {
        Que->data[size++] = item;
    } else {
        priority_queue tmp = realloc();
    }

}
