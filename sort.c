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

void merge (void *base, int range1, int range2, size_t size, int type, int (* cmpfunc)(void *, void *), char *tmp1, char *tmp2) {
	memcpy(tmp1, base, range1 * size);
	memcpy(tmp2, (char *)(base + range1 * size), range2 * size);
	int num1 = 0, num2 = 0; // 仮配列のインデックス
	int basenum = 0; // もとの配列のインデックス
	if (type == 1) {
		for (; ;) {
			if (cmpfunc(tmp1 + size * num1, tmp2 + size * num2) != 1) {
				memcpy(base + size * basenum, tmp1 + size * num1, size);
				num1++;
			} else {
				memcpy(base + size * basenum, tmp2 + size * num2, size);
				num2++;
			}
			basenum++;

			/* 片方の要素が尽きた時 */
			if (num1 == range1) {
				memcpy(base + size * basenum, tmp2 + size * num2, size * (range2 - num2));
				return;
			} else if (num2 == range2) {
				memcpy(base + size * basenum, tmp1 + size * num1, size * (range1 - num1));
				return;
			}
		}
	} else {
		for (; ;) {
			if (cmpfunc(tmp1 + size * num1, tmp2 + size * num2) == 1) {
				memcpy(base + size * basenum, tmp1 + size * num1, size);
				num1++;
			} else {
				memcpy(base + size * basenum, tmp2 + size * num2, size);
				num2++;
			}
			basenum++;

			/* 片方の要素が尽きた時 */
			if (num1 == range1) {
				memcpy(base + size * basenum, tmp2 + size * num2, size * (range2 - num2 - 1));
				return;
			} else if (num2 == range2) {
				memcpy(base + size * basenum, tmp1 + size * num1, size * (range1 - num1 - 1));
				return;
			}
		}
	}
}

void mergesort (void *base, size_t num, size_t size, int (* cmpfunc)(void *, void *), int type) {
	char *tmp1 = malloc(num * size);
	char *tmp2 = malloc(num * size);
	int range = 1; // マージする2つのブロックの一つ分の大きさ
	for (; num > range;) {
		long long int roop = num / (2 * range);
		for (int i = 0; roop > i; i++) { // まずはrange分を2つずつ取る
			merge((char *)(base + 2 * i * range * size), range, range, size, type, cmpfunc, tmp1, tmp2);
		}
		if (num - roop * 2 * range > range) {
			merge((char *)(base + 2 * roop * range * size), range, num - roop * 2 * range - range, size, type, cmpfunc, tmp1, tmp2);
		}
		range *= 2;
	}
	free(tmp1);
	free(tmp2);
}

/* ----------------- mergesort ここまで -------------------- */
