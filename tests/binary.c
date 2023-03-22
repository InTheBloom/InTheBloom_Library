#include <stdio.h>
#include <stdlib.h>
#include "../src/binary_search_tree.c"

int main (void) {

	node_data_t keytmp;
	keytmp.num = 10;

	node_t *root = create_root(keytmp);

	for (int i = 0; 9 > i; i++) {
		keytmp.num = i;
		add_node(root, keytmp, cmpfunc);
	}

	keytmp.num = 25;
	node_t *item = search_node(root, keytmp, cmpfunc);
	if (item == NULL) {
		printf("NULL\n");
	} else {
		printf("%i\n", item->data.num);
	}

	return 0;
}
