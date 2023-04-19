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

struct node_queue {
	struct node_queue *previous;
	struct node_queue *next;
	int data;
};

typedef struct node_queue * node_queue;

struct queue {
	size_t size;
	node_queue head;
	node_queue tail;
};

typedef struct queue * queue;

queue create_queue (void) {

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

void destroy_queue (queue x) {
	for (; x->head != NULL; x->head = x->head->next) {
		free(x->head);
	}

	free(x);
	x = NULL;
}

void enqueue (queue x, int y) {

	node_queue new_node = malloc(sizeof(struct node_queue));
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

int front_queue (queue x) {
	if (x->size == 0) {
		fprintf(stderr, "queue is empty! 'front_queue'\n");
		return -1010101; // error number
	}

	int DATA = x->head->data;

	if (x->size > 1) {
		node_queue tmp = x->head->next;
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

int back_queue (queue x) {
	if (x->size == 0) {
		fprintf(stderr, "queue is empty! 'back_queue'\n");
		return -1010101; // error number
	}

	int DATA = x->tail->data;

	if (x->size > 1) {
		node_queue tmp = x->tail->previous;
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
