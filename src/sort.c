/* you have to include */
#include <stdlib.h>
#include <string.h>

/* heapsort(bundle) */

void swap_all (void *n1, void *n2, size_t size) {
	char tmp[size];
	memcpy(tmp, n1, size);
	memcpy(n1, n2, size);
	memcpy(n2, tmp, size);
}

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

/* mergesort(bundle) */

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

/* Compare Functions */

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
		if (a[i] > b[i]) {
			return 1;
		} else if (a[i] < b[i]) {
			return -1;
		}
	}
	return 0;
}
