#include <stdio.h>
#include <stdlib.h>
#include "../src/queue_stack.c"

int main (void) {

	queue Queue = create_queue();


	for (int i = 0; i < 10; i++) {
		enqueue(Queue, i);
	}

	for (int i = 0; i < 5; i++) {
		printf("%i ", front_queue(Queue));
	}
	printf("\n");

	for (int i = 0; i < 10; i++) {
		enqueue(Queue, i + 20);
	}

	for (int i = 0; i < 10; i++) {
		printf("%i ", front_queue(Queue));
	}
	printf("\n");

	destroy_queue(Queue);

	return 0;
}
