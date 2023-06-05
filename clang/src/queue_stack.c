/* you need to include */
#include <stdio.h>
#include <stdlib.h>

/* queue and stack */

/*            queue OVERVIEW              */
/*                                        */
/*                Queue                   */
/*               /    \                   */
/*            front   tail                */
/*                                        */
/*                DATA                    */
/* front -> item1 -> item2 -> ... -> tail */
/*                                        */
/*            prev <- -> next             */
/*                                        */

struct queue_node {
    struct queue_node *previous;
    struct queue_node *next;
    long long data;
};

typedef struct queue_node * queue_node;

struct queue {
    size_t size;
    queue_node head;
    queue_node tail;
};

typedef struct queue * queue;

queue queue_create (void) {

    queue x = malloc(sizeof(struct queue));
    if (x == NULL) {
        fprintf(stderr, "memory allocate failed in 'create_queue'.\n");
        exit(EXIT_FAILURE);
    }

    x->size = 0;
    x->head = NULL;
    x->tail = NULL;

    return x;
}

void queue_destroy (queue x) {
    for (; x->head != NULL; x->head = x->head->next) {
        free(x->head);
    }

    free(x);
    x = NULL;
}

void queue_clear (queue x) {
    for (; x->head != NULL; x->head = x->head->next) {
        free(x->head);
    }

    x->size = 0;
    x->head = NULL;
    x->tail = NULL;
}

void queue_enqueue (queue x, long long y) {

    queue_node new_node = malloc(sizeof(struct queue_node));
    if (new_node == NULL) {
        fprintf(stderr, "memory allocate failed in 'push_back_queue'.\n");
        exit(EXIT_FAILURE);
    }

    new_node->data = y;
    new_node->previous = NULL;
    new_node->next = NULL;

    // if queue doesn't have node
    if (x->size == 0) {
        x->head = new_node;
        x->tail = new_node;
        x->size++;
    } else {
        new_node->previous = x->tail;
        x->tail->next = new_node;
        x->tail = new_node;
        x->size++;
    }
}

long long queue_front (queue x) {
    if (x->size == 0) {
        fprintf(stderr, "queue is empty! 'front_queue'\n");
        return -1010101; // error number
    }

    long long DATA = x->head->data;

    if (x->size > 1) {
        queue_node tmp = x->head->next;
        tmp->previous = NULL;

        free(x->head);

        x->head = tmp;
        x->size--;
    } else {
        free(x->head);

        x->head = NULL;
        x->tail = NULL;
        x->size--;
    }

    return DATA;
}

long long queue_back (queue x) {
    if (x->size == 0) {
        fprintf(stderr, "queue is empty! 'back_queue'\n");
        return -1010101; // error number
    }

    long long DATA = x->tail->data;

    if (x->size > 1) {
        queue_node tmp = x->tail->previous;
        tmp->next = NULL;

        free(x->tail);

        x->tail = tmp;
        x->size--;
    } else {
        free(x->head);

        x->head = NULL;
        x->tail = NULL;
        x->size--;
    }

    return DATA;
}
