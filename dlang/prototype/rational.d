import std.bigint;

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

struct rational (T)
if (
    is (T == int) ||
    is (T == long) ||
    is (T == std.bigint.BigInt)
    )
{
    // Dependent on
    import std.exception : enforce;
    import std.format : format;
    import std.numeric;
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
        auto GCD = std.numeric.gcd(numerator, denominator);
        if (1 < GCD) {
            numerator /= GCD; denominator /= GCD;
        }

        /* 符号正規化 */
        if (denominator < 0) {
            numerator *= -1; denominator *= -1;
        }
    }

    /** -- opUnary -- **/
    const auto opUnary (string op : "+") ()
    {
        return this;
    }

    auto opUnary (string op : "-") ()
    {
        numerator *= -1;
        return this;
    }

    /** -- opBinary -- **/
    const auto opBinary (string op : "+") (rational!T rhs)
    {
        /* (a/b) + (c/d) = (ad+bc)/bd */
        return
            rational!T(
                (this.numerator * rhs.denominator) + (rhs.numerator * this.denominator),
                (this.denominator * rhs.denominator)
                );
    }

    const auto opBinary (string op : "-") (rational!T rhs)
    {
        /* (a/b) - (c/d) = (a/b) + ((-c)/b) */
        return opBinary!"+"(-rhs);
    }

    const auto opBinary (string op : "*") (rational!T rhs)
    {
        /* (a/b) * (c/d) = ((a*c)/(b*d)) */
        T num = this.numerator;
        T den = this.denominator;

        // GCD1 = gcd(a, d), GCD2 = gcd(b, c)
        auto GCD1 = std.numeric.gcd(num, rhs.denominator);
        auto GCD2 = std.numeric.gcd(den, rhs.numerator);

        num /= GCD1;
        den /= GCD2;

        num *= rhs.numerator / GCD2; den *= rhs.denominator / GCD1;

        return rational!T(num, den);
    }

    const auto opBinary (string op : "/") (rational!T rhs)
    {
        /* (a/b) / (c/d) = (a/b) * (d/c) */
        return opBinary!"*"(rational!T(rhs.denominator, rhs.numerator));
    }

    // いろんな型に対応させる。
    const auto opBinary (string op, E) (E rhs)
    if ((op == "+" || op == "-" || op == "*" || op == "/") &&
        __traits(compiles, rational!(T)(rhs)))
    {
        auto ret = rational!(T)(rhs);
        return opBinary!(op)(ret);
    }

    /** -- opAssign -- **/
    void opAssign (rational!T rhs) {
        numerator = rhs.numerator;
        denominator = rhs.denominator;
    }

    void opAssign (E) (rational!E rhs)
    if (__traits(compiles, rhs.numerator.to!(T) && rhs.denominator.to!(T)))
    {
        numerator = rhs.numerator.to!(T);
        denominator = rhs.denominator.to!(T);
        normalization();
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
        this.numerator *= rhs.denominator;
        this.numerator += this.denominator * rhs.numerator;

        this.denominator *= rhs.denominator;
        normalization();
    }

    void opOpAssign (string op : "-") (rational!T rhs)
    {
        rhs.numerator *= -1;
        opOpAssign!"+"(rhs);
    }

    void opOpAssign (string op : "*") (rational!T rhs)
    {
        auto GCD1 = std.numeric.gcd(numerator, rhs.denominator);
        auto GCD2 = std.numeric.gcd(denominator, rhs.numerator);

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

    real toDecimal () {
        real num = numerator.to!real;
        real den = denominator.to!real;
        return num/den;
    }
}

void main () {
    // verifying with ABC308C - Standings
    solve();
}

void solve () {
    import std;
    int N = readln.chomp.to!int;
    alias pair = Tuple!(rational!(long), "val", int, "idx");
    pair[] person = new pair[](N);

    foreach (i; 0..N) {
        int A, B; readf!" %d %d"(A, B);
        person[i].val = rational!(long)(A, A+B);
        person[i].idx = i+1;
    }

    person.sort!((a, b) => (a.val == b.val ? a.idx < b.idx : a.val > b.val));

    foreach (i, p; person) {
        write(p.idx, (i == person.length-1 ? '\n' : ' '));
    }
}
