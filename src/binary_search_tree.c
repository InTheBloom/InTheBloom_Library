/* 構造体 */

typedef struct {
	int num;
} node_data_t;

typedef struct node {
	node_data_t data;
	struct node *left;
	struct node *right;
} node_t;

/* 関数郡 */

node_t *create_root (node_data_t x) { // 根ノードの作成
	node_t *root = malloc(sizeof(node_t));
	if (root == NULL) {
		fprintf(stderr, "Bad malloc(create_root)\n");
		exit(EXIT_SUCCESS);
	}
	root->left = NULL;
	root->right = NULL;
	root->data = x;

	return root;
}

void add_node (node_t *root, node_data_t Data, int (*cmpfunc)(node_data_t, node_data_t)) {

	node_t *leaf = malloc(sizeof(node_t));
	if (leaf == NULL) {
		fprintf(stderr, "Bad malloc(add_node)\n");
		exit(EXIT_SUCCESS);
	}
	leaf->left = NULL;
	leaf->right = NULL;
	leaf->data = Data;

	for (; ;) {

		if (cmpfunc(leaf->data, root->data) == 1) {
			if (root->right != NULL) {
				root = root->right;
			} else {
				root->right = leaf;
				root = root->right;
				return;
			}
		} else {
			if (root->left != NULL) {
				root = root->left;
			} else {
				root->left = leaf;
				root = root->left;
				return;
			}
		}
	}
}

node_t *search_node (node_t *root, node_data_t key, int (*cmpfunc)(node_data_t, node_data_t)) {

	for (; ;) {
		if (root == NULL) { // 探索失敗
			return NULL;
		}

		int yesno = cmpfunc(root->data, key);
		if (yesno == 0) {
			return root;
		} else if (yesno == 1) {
			root = root->left;
		} else {
			root = root->right;
		}
	}
}

int cmpfunc (node_data_t n1, node_data_t n2) { // 仮
	int x = n1.num;
	int y = n2.num;
	if (x > y) {
		return 1;
	} else if (x < y) {
		return -1;
	}
	return 0;
}
