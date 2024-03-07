class ZobristHash (T) {
    import std.random : uniform;

    private:
        bool[T] set;
        long hash = 0;

        // 全インスタンス共通
        static long[T] element_to_integer_map;
        static bool[long] integer_map;

    public:
        this () {}

        import std.range : isInputRange;
        this (R) (R A)
        if (isInputRange!(R))
        {
            foreach (a; A) insert(a);
        }

        void insert (T x) {
            while (x !in element_to_integer_map) {
                long v = uniform!"[]"(1, long.max);
                if (v in integer_map) continue;
                integer_map[v] = true;

                element_to_integer_map[x] = v;
            }

            if (x in set) return;
            set[x] = true;
            hash ^= element_to_integer_map[x];
        }

        // in式のオーバーロード
        bool opBinaryRight (string op) (T key)
        if (op == "in")
        {
            return (key in set) !is null;
        }

        void remove (T x)
        in {
            import std.format : format;
            assert(x in set, format("ZobristHash.remove : %s is not in the set yet.", x));
        }
        do {
            set.remove(x);
            hash ^= element_to_integer_map[x];
        }

        long get () {
            return hash;
        }

        override string toString () {
            import std.format : format;
            string res = "========= dump of class ZobristHash =========\n";
            res ~= "Set = {";
            foreach (key, val; set) res ~= format("%s, ", key);
            res = res[0..$-2];
            res ~= "}\n\n";

            res ~= "Mapping:\n";
            res ~= "---------------------------------------------\n";
            foreach (key, val; element_to_integer_map) {
                res ~= format("%20s => %20s\n", key, val);
            }
            res ~= "---------------------------------------------\n";

            res ~= "=============================================";
            return res;
        }
}
