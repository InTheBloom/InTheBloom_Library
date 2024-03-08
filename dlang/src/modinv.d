// check mod_pow
static assert(__traits(compiles, mod_pow(2, 10, 998244353)));

long mod_inv (const long x, const long MOD)
in {
    import std.format : format;
    assert(1 <= MOD, format("MOD must satisfy 1 <= MOD. Now MOD =  %s.", MOD));
    assert(MOD <= int.max, format("MOD must satisfy MOD*MOD <= long.max. Now MOD = %s.", MOD));
}
do {
    return mod_pow(x, MOD-2, MOD);
}
