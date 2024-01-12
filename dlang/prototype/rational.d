/**
___
# 有理数型`rational(T)`

## 特徴
- 実体化が許可されるTは現状`int`/`long`/`std.bigint.BigInt`のみ
- 分母の0は常に許容されない。
- 常に正規形を保つ(分母と分子が互いに素/負数は分子が負/分子が0なら分母は必ず1)
- 演算子'+', '-', '*', '/'及び'=', '+=', '-=', '*=', '/='のオーバーロード
- 比較演算子'==', '!=', '>', '>=', '<', '<='のオーバーロード

## コンストラクタ
- コンストラクタに渡せるのは`std.conv.to`により`T`に変換できるもののみ。
- コンストラクタは`(分子, 分母)`あるいは`(分子)`を受け付ける。

## 演算子オーバーロード
- 各種演算はオーバーフローの可能性があり、それを検出する機構は無いため、十分に注意する必要がある。。
- (代入演算を含む)二項演算の相手が`rational!T`でない場合、次の2つのどちらか片方を満たせば演算が可能
  1. `T`と異なる型`E`を用いて、`rational!E`であり、かつ`std.conv.to`により`E`を`T`に変換可能。
  2. `std.conv.to`により`T`に変換可能な型であって、`this (E) (E num)`コンストラクタにより`rational!T`に変換可能。

## 小数近似
- `toDecimal()`を呼び出すと、分子と分母を`std.conv.to`により`real`に変換した値を用いて小数近似した結果を返す。
___
 */

import std.bigint;
struct rational (T)
if (
    is (T == int) ||
    is (T == long) ||
    is (T == std.bigint.BigInt)
    )
{
    // Depends on
    import std.exception : enforce;
    import std.format : format;
    import std.conv : to;

    T numerator;
    T denominator = 1.to!(T);

    /* -- constructors -- */
    this (E1, E2) (E1 num, E2 deno, int place = __LINE__)
    if (__traits(compiles, (num.to!(T))) && __traits(compiles, (deno.to!(T))))
    in {
        enforce(deno != 0, format("Line %s : Denominator must not equal to zero.", place));
    }
    do {
        numerator = num.to!(T), denominator = deno.to!(T);
        normalization();
    }

    this (E) (E num)
    if (__traits(compiles, (num.to!(T))))
    {
        numerator = num.to!(T), denominator = 1.to!(T);
        normalization();
    }

    /* -- invariant -- */
    invariant {
        enforce(denominator != 0, format("In struct rational!(%s) : zero division occured.", T.stringof));
    }

    /* -- methods -- */
    void normalization () {
        /* std.bigint.BigIntで-0とかいう謎の数が生成される可能性があるので、判定をこうしてる */
        if (-1 < numerator && numerator < 1) { numerator = 0; denominator = 1; return; }

        /* 互いに素にする */
        auto GCD = this.rational_gcd(numerator, denominator);
        if (1 < GCD) {
            numerator /= GCD; denominator /= GCD;
        }

        /* 符号正規化 */
        if (denominator < 0) {
            numerator *= -1; denominator *= -1;
        }
    }

    /** -- opUnary -- **/
    auto opUnary (string op : "+") ()
    {
        return this;
    }

    auto opUnary (string op : "-") ()
    {
        numerator *= -1;
        return this;
    }

    /** -- opBinary -- **/
    auto opBinary (string op : "+") (rational!T rhs)
    {
        /* (a/b) + (c/d) = (ad+bc)/bd */
        /* boost/rationalの計算を参考にした。
           (https://github.com/boostorg/rational/blob/develop/include/boost/rational.hpp) */
        auto g = this.rational_gcd(this.denominator, rhs.denominator);

        auto b1 = this.denominator / g;
        auto d1 = rhs.denominator / g;

        auto res = rational!T(0);
        res.numerator = (this.numerator * d1) + (rhs.numerator * b1);
        res.denominator = b1 * d1 * g;

        auto div = this.rational_gcd(res.numerator, g);
        res.numerator /= g, res.denominator /= g;
        return res;
    }

    auto opBinary (string op : "-") (rational!T rhs)
    {
        /* (a/b) - (c/d) = (a/b) + ((-c)/b) */
        return opBinary!"+"(-rhs);
    }

    auto opBinary (string op : "*") (rational!T rhs)
    {
        /* (a/b) * (c/d) = ((a*c)/(b*d)) */
        T num = this.numerator;
        T den = this.denominator;

        // GCD1 = gcd(a, d), GCD2 = gcd(b, c)
        auto GCD1 = this.rational_gcd(num, rhs.denominator);
        auto GCD2 = this.rational_gcd(den, rhs.numerator);

        num /= GCD1;
        den /= GCD2;

        num *= rhs.numerator / GCD2; den *= rhs.denominator / GCD1;

        auto res = rational!T(0);
        res.numerator = num, res.denominator = den;

        return res;
    }

    auto opBinary (string op : "/") (rational!T rhs)
    in {
        assert(rhs != rational!T(0), "Zero division.");
    }
    do {
        /* (a/b) / (c/d) = (a/b) * (d/c) */
        auto res = rational!T(0);
        res.numerator = rhs.denominator, res.denominator = rhs.numerator;
        return opBinary!"*"(res);
    }

    // いろんな型に対応させる。
    auto opBinary (string op, E) (E rhs)
    if ((op == "+" || op == "-" || op == "*" || op == "/") &&
        __traits(compiles, rational!(T)(rhs)))
    {
        auto ret = rational!(T)(rhs);
        return opBinary!(op)(ret);
    }

    /** -- opBinaryRight -- **/
    auto opBinaryRight (string op, E) (E lhs)
    if ((op == "+" || op == "-" || op == "*") &&
        __traits(compiles, rational!(T)(lhs)))
    {
        auto ret = rational!(T)(lhs);
        return opBinary!(op)(ret);
    }

    auto opBinaryRight (string op, E) (E lhs)
    if ((op == "/") &&
        __traits(compiles, rational!(T)(lhs)))
    {
        auto ret = rational!(T)(lhs);
        return opBinary!("*")(rational!T(ret.deno, ret.num));
    }

    /** -- opAssign -- **/
    void opAssign (rational!T rhs) {
        numerator = rhs.numerator;
        denominator = rhs.denominator;
    }

    void opAssign (E) (E rhs)
    if (__traits(compiles, rhs.to!(T)))
    {
        numerator = rhs.to!(T);
        denominator = 1.to!(T);
        normalization();
    }

    /** -- opOpAssign -- **/
    void opOpAssign (string op : "+") (rational!T rhs)
    {
        auto g = this.rational_gcd(rhs.denominator, this.denominator);
        this.denominator /= g;
        this.numerator = this.numerator * (rhs.denominator / g) + rhs.numerator * this.denominator;
        g = this.rational_gcd(this.numerator, g);
        this.numerator /= g;
        this.denominator *= rhs.denominator/g;
    }

    void opOpAssign (string op : "-") (rational!T rhs)
    {
        rhs.numerator *= -1;
        opOpAssign!"+"(rhs);
    }

    void opOpAssign (string op : "*") (rational!T rhs)
    {
        auto GCD1 = this.rational_gcd(numerator, rhs.denominator);
        auto GCD2 = this.rational_gcd(denominator, rhs.numerator);

        numerator /= GCD1; denominator /= GCD2;

        numerator *= rhs.numerator / GCD2;
        denominator *= rhs.denominator / GCD1;
    }

    void opOpAssign (string op : "/") (rational!T rhs)
    {
        opOpAssign!"*"(rational!T(rhs.denominator, rhs.numerator));
    }

    // いろんな型に対応させる。
    void opOpAssign (string op, E) (E rhs)
    if ((op == "+" || op == "-" || op == "*" || op == "/") &&
            __traits(compiles, rational!(T)(rhs)))
    {
        auto ret = rational!(T)(rhs);
        opOpAssign!(op)(ret);
    }

    string toString () {
        return format("%s/%s", numerator, denominator);
    }

    /** -- opEqual -- **/
    bool opEqual (rational!T rhs) {
        return this.numerator == rhs.numerator && this.denominator == rhs.denominator;
    }

    /** -- opCmp -- **/
    int opCmp (rational!T rhs) {
        /* (a/b) < (c/d) := ad < bc */
        T left = this.numerator * rhs.denominator;
        T right = this.denominator * rhs.numerator;
        if (left < right) return -1;
        if (right < left) return 1;
        return 0;
    }

    string toDecimal (size_t digits = 10) {
        string res;
        auto num = numerator;
        auto den = denominator;
        bool minus = false;

        if (num < 0) {
            num = -num;
            minus = true;
        }

        foreach (i; 0..digits) {
            res ~= (num/den).to!string;
            if (i == 0) res ~= '.';
            num %= den;
            num *= 10;
        }
        if (minus) res = "-" ~ res;
        return res;
    }

    T rational_gcd (T x, T y) {
        T tmp;
        while (y != 0) {
            tmp = y;
            y = x % y;
            x = tmp;
        }
        return x;
    }
}
