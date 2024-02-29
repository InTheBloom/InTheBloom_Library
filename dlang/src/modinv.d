long mod_inv (const long x, const long MOD)
in {
    import std.format : format;
    assert(1 <= MOD, format("MOD must satisfy 1 <= MOD. Now MOD =  %s.", MOD));
    assert(MOD <= int.max, format("MOD must satisfy MOD*MOD <= long.max. Now MOD = %s.", MOD));
}
do {
    return ModPow(x, MOD-2, MOD);
}
