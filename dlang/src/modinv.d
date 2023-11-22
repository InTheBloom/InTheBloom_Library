long modInv (ref const long x, ref const long MOD) {
    import std.exception : enforce;
    import std.format : format;
    enforce(1 <= MOD, format("MOD must satisfy 1 <= MOD. Now MOD =  %s.", MOD));
    enforce(MOD <= int.max, format("MOD must satisfy MOD*MOD <= long.max. Now MOD = %s.", MOD));
    return modPow(x, MOD-2, MOD);
}
