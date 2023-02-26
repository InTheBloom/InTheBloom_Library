/////////////////////////////////////
/*                                 */
/*   InTheBloom's Library          */
/*   author: InTheBloom            */
/*   content: sorting algorithms   */
/*                                 */
/////////////////////////////////////

/* 関数定義 */

void heapsort (void *base, size_t num, size_t size, int (* cmpfunc)(void *, void *), int type);
void mergesort (void *base, size_t num, size_t size, int (* cmpfunc)(void *, void *), int type);
void swap_all (void *n1, void *n2, size_t size);

/* - 使い方 - */

/* swap_all関数は，任意の同じ型の変数へのポインタを受け取って入れ替えます。第一引数，第二引数に同じ型の変数へのポインタを，第三引数にその変数のメモリサイズをとります。ただし，通常の(型を指定した)swap関数よりも約4倍遅いです。
 */

/* 使用例
 * int a = 0, b = 10;
 * swap_all(&a, &b, sizeof(int));
 * printf("%i", a); -> 10
 */

/* heapsort関数とmergesort関数は，内部のソートアルゴリズムが少し違うだけで，基本的に使い方は同じです。実行時間がシビアな時に使うとTLEすると思います。(おそらく定数倍そんなに良くないです。)
 * heapsortはin-placeでO(nlog(n))オーダーのソートをします。mergesortは空間O(n)を使用してO(nlog(n))オーダーのソートをします。定数倍はmergesortのほうが基本的に2倍程度良いです。あと、mergesortは安定ソートです。
 * 第一引数: ソートしたいデータ配列の先頭へのポインタ
 * 第二引数: 第一引数で指されているものを一つ目として，ソートしたい要素数
 * 第三引数: ソートしたいデータ型のバイト数
 * 第四引数: ソートしたいデータのポインタを渡すことで，順序関係を返す関数への関数ポインタ(この関数は必ず形式に従わないといけない)
 * 第五引数: typeが1の時，昇順ソートする。typeが-1の時，降順ソートする。それ以外は未定義動作とする
 */

/* 比較関数の詳細について
 * 比較関数は，ソートしたいデータのポインタ二つを受け取って，「第一引数が先」の時に1を，「第二引数が先」の時に-1を，「順番として同じ」とき0を返すように作ること
 */

/* 使用例
   char *t[n];
 * int mystrcmp (char *a, char *b);
 * heapsort(t, n, sizeof(char *), mystrcmp, 1);
 */

/* 比較関数の例 */

// char比較
int ch_cmp (void *n1, void *n2) {
	char a = *(char *)n1;
	char b = *(char *)n2;
	if (a > b) {
		return 1;
	} else if (a < b) {
		return -1;
	} else {
		return 0;
	}
}

// int比較
int i_cmp (void *n1, void *n2) {
	int a = *(int *)n1;
	int b = *(int *)n2;
	if (a > b) {
		return 1;
	} else if (a < b) {
		return -1;
	} else {
		return 0;
	}
}

// long long int比較
int lli_cmp (void *n1, void *n2) {
	long long int a = *(long long int *)n1;
	long long int b = *(long long int *)n2;
	if (a > b) {
		return 1;
	} else if (a < b) {
		return -1;
	} else {
		return 0;
	}
}

// 文字列比較(注意！ char *を渡してはいけない！ あくまでソート関数用なので、char **を渡すように！)
int str_cmp (void *n1, void *n2) {
	char *a = *(char **)n1;
	char *b = *(char **)n2;
	for (int i = 0; a[i] != '\0' || b[i] != '\0'; i++) {
		if (a[i] < b[i]) {
			return 1;
		} else if (a[i] > b[i]) {
			return -1;
		}
	}
	return 0;
}

void swap_all (void *n1, void *n2, size_t size) {
	char tmp[size];
	memcpy(tmp, n1, size);
	memcpy(n1, n2, size);
	memcpy(n2, tmp, size);
}

/* ------------- heapsort ---------------- */

void heapsort (void *base, size_t num, size_t size, int (* cmpfunc)(void *, void *), int type) {
	for (int i = 1; num > i; i++) {
		for (int j = i; j > 0;) {
			if (type == 1) {
				if (cmpfunc((char *)(base + size * j), (char *)(base + size * ((j - 1) / 2))) == 1) {
					swap_all((char *)(base + size * j), (char *)(base + size * ((j - 1) / 2)), size);
					j = (j - 1) / 2;
				} else {
					break;
				}
			} else {
				if (cmpfunc((char *)(base + size * j), (char *)(base + size * ((j - 1) / 2))) == -1) {
					swap_all((char *)(base + size * j), (char *)(base + size * ((j - 1) / 2)), size);
					j = (j - 1) / 2;
				} else {
					break;
				}
			}
		}
	}

	for (int i = num - 1; i > 0; i--) {
		swap_all((char *)base, (char *)(base + size * i), size);
		for (int j = 0; ;) {
			int lch = 2 * j + 1, rch = 2 * j + 2, rep;
			if (i > rch) {
				if (type == 1) {
					rep = (cmpfunc((char *)(base + size * lch), (char *)(base + size * rch)) == 1 ? lch : rch);
				} else {
					rep = (cmpfunc((char *)(base + size * lch), (char *)(base + size * rch)) == -1 ? lch : rch);
				}
			} else if (rch == i) {
				rep = lch;
			} else {
				break;
			}
			if (type == 1) {
				if (cmpfunc((char *)(base + size * j), (char *)(base + size * rep)) == -1) {
					swap_all((char *)(base + size * j), (char *)(base + size * rep), size);
					j = rep;
				} else {
					break;
				}
			} else {
				if (cmpfunc((char *)(base + size * j), (char *)(base + size * rep)) == 1) {
					swap_all((char *)(base + size * j), (char *)(base + size * rep), size);
					j = rep;
				} else {
					break;
				}
			}
		}
	}
}

/* --------------- heapsortここまで ----------------- */


/* --------------- mergesort ---------------------- */

void merge (void *base1, int range1, void *base2, int range2, int (*cmpfunc)(void *, void *), size_t size, int type, char *tmp) {
	int base1_current = 0, base2_current = 0;
	int roop = range1 + range2;
	for (int i = 0; roop > i; i++) {
		if (cmpfunc((base1 + base1_current * size), (base2 + base2_current * size)) == 1) {
			if (type == 1) {
				for (int j = 0; size > j; j++) {
					tmp[i * size + j] = *(char *)(base2 + base2_current * size + j);
				}
				base2_current++;
			} else {
				for (int j = 0; size > j; j++) {
					tmp[i * size + j] = *(char *)(base1 + base1_current * size + j);
				}
				base1_current++;
			}
		} else {
			if (type == 1) {
				for (int j = 0; size > j; j++) {
					tmp[i * size + j] = *(char *)(base1 + base1_current * size + j);
				}
				base1_current++;
			} else {
				for (int j = 0; size > j; j++) {
					tmp[i * size + j] = *(char *)(base2 + base2_current * size + j);
				}
				base2_current++;
			}
		}

		if (base1_current >= range1) {
			for (i += 1; roop > i; ) {
				for (int j = 0; size > j; j++) {
					tmp[i * size + j] = *(char *)(base2 + base2_current * size + j);
				}
				base2_current++;
				i++;
			}
		} else if (base2_current >= range2) {
			for (i += 1; roop > i; ) {
				for (int j = 0; size > j; j++) {
					tmp[i * size + j] = *(char *)(base1 + base1_current * size + j);
				}
				base1_current++;
				i++;
			}
		}
	}

	for (int i = 0; range1 > i; i++) {
		for (int j = 0; size > j; j++) {
			*(char *)(base1 + i * size + j) = tmp[i * size + j];
		}
	}
	for (int i = 0; range2 > i; i++) {
		for (int j = 0; size > j; j++) {
			*(char *)(base2 + i * size + j) = tmp[range1 * size + i * size + j];
		}
	}
}

void mergesort (void *base, size_t num, size_t size, int (* cmpfunc)(void *, void*), int type) {
	char *tmp = malloc(num * size);
	int range = 1;
	for (; num > range; range *= 2) {
		for (int current = 1; num > current; ) { // currentは1から数えた配列のインデックス
			if (num >= current + 2 * range - 1) {
				merge((char *)(base + (current - 1) * size), range, (char *)(base + (current - 1) * size + size * range), range, cmpfunc, size, type, tmp);
				current += 2 * range;
			} else if (current + 2 * range - 1 > num && num >= current + range - 1) {
				merge((char *)(base + size * (current - 1)), range, (char *)(base + size * (current - 1) + size * range), num - current - range + 1, cmpfunc, size, type, tmp);
				break;
			} else {
				break;
			}
		}
	}
	free(tmp);
}

/* ----------------- mergesort ここまで -------------------- */
