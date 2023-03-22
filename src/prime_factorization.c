/* prime factorization(bundle) */

#define PRIME_NUM_SUP 25
typedef struct {
	unsigned long long int fact[PRIME_NUM_SUP];
	int pow[PRIME_NUM_SUP];
} prime_t;

unsigned long long int bs (unsigned long long int m) {
	unsigned long long int left = 0, right;
	right = (m > 4294967294 ? 4294967294 : m);
	for (; right - left > 2;) {
		unsigned long long int center = (left + right) / 2;
		if (center * center > m) {
			right = center;
		} else {
			left = center;
		}
	}
	for (; m >= left * left; left++) {}
	return left;
}

prime_t factorization (unsigned long long int n, unsigned long long int lim) {
	static const unsigned long long int max = 18445744081446774400ULL;
	static const long long int max_root = 4294850880;
	int flag = 0;
	prime_t x;
	int idx = 0;
	for (int i = 0; PRIME_NUM_SUP > i; x.fact[i] = 0, x.pow[i++] = -1) {}
	unsigned long long int left;
	if (lim != -1) {
		left = lim + 1;
	} else if (n >= max) {
		left = max_root;
	} else {
		left = bs(n);
	}
	for (int i = 2; left > i; i++) {
		if (n % i == 0) {
			x.fact[idx] = i;
			int tmp = 0;
			for (; n % i == 0; n /= i, tmp++) {}
			x.pow[idx++] = tmp;
			if (n == 1) {
				break;
			}
			if (lim == -1) {
				left = bs(n);
			}
		}
	}
	if (lim != -1) {
		return x;
	}
	if (n != 1) {
		x.fact[idx] = n;
		x.pow[idx] = 1;
	}
	return x;
}
