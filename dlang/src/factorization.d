struct factorization {
    bool isFactorized = false;
    long target;

    this (long target_, long upto = long.max) {
        // check
        assert(0 < target_);
        target = target_;
    }
}
