import std;

struct Factors {
    long target;
    long[] factor;
    long[] pow;
    bool is_prime () {
        if (target <= 0) {
            return false;
        }
        if (factor.length == 2 && pow[1] == 1) {
            return true;
        }
        return false;
    }
    long[] combine_factor () {
        if (target <= 0) {
            return [];
        }
        long[] ret;
        foreach (i, x; pow) {
            foreach (k; 0..x) {
                ret ~= factor[i];
            }
        }
        return ret;
    }

    this (long target_) {
        { // check input
            assert(0 < target_);
        }
        target = target_;
        factor = [];
        pow = [];

        pow ~= 1;
        factor ~= 1;

        foreach (i; 2..target_) {
            if (target_ < i*i) {
                break;
            }
            if (target_ % i == 0) {
                factor ~= i;
                pow ~= 0;
                while (target_ % i == 0) {
                    target_ /= i;
                    pow[$-1]++;
                }
            }
        }
        if (target_ != 1) {
            factor ~= target_;
            pow ~= 1;
        }
    }
}

void main () {
    Factors x = Factors(uniform(1, 1000000000));

    writeln(x.combine_factor);
    writeln(x.is_prime);
    writeln(x);
}
